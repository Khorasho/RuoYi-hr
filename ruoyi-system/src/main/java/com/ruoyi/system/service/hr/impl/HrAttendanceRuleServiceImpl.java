package com.ruoyi.system.service.hr.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.hr.HrAttendanceRule;
import com.ruoyi.system.mapper.hr.HrAttendanceRuleMapper;
import com.ruoyi.system.service.hr.IHrAttendanceRuleService;

@Service
public class HrAttendanceRuleServiceImpl implements IHrAttendanceRuleService
{
    @Autowired
    private HrAttendanceRuleMapper ruleMapper;

    @Override
    public HrAttendanceRule selectActiveRule()
    {
        return ruleMapper.selectActiveRule();
    }

    @Override
    public int updateHrAttendanceRule(HrAttendanceRule rule)
    {
        validateRule(rule);
        HrAttendanceRule current = ruleMapper.selectActiveRule();
        if (current == null)
        {
            if (rule.getRuleId() == null)
            {
                rule.setRuleId(1L);
            }
            rule.setCreateBy(rule.getUpdateBy());
            return ruleMapper.insertHrAttendanceRule(rule);
        }
        return ruleMapper.updateHrAttendanceRule(rule);
    }

    private void validateRule(HrAttendanceRule rule)
    {
        if (rule == null)
        {
            throw new ServiceException("规则参数不能为空");
        }
        if (rule.getLateMinutes() == null || rule.getLateMinutes() < 0 || rule.getLateMinutes() > 240)
        {
            throw new ServiceException("迟到阈值必须在0到240分钟之间");
        }
        if (rule.getEarlyMinutes() == null || rule.getEarlyMinutes() < 0 || rule.getEarlyMinutes() > 240)
        {
            throw new ServiceException("早退阈值必须在0到240分钟之间");
        }
        if (rule.getAbsentMinutes() == null || rule.getAbsentMinutes() < 0 || rule.getAbsentMinutes() > 1440)
        {
            throw new ServiceException("旷工容差必须在0到1440分钟之间");
        }
        if (rule.getDayCloseMinutes() == null || rule.getDayCloseMinutes() < 0 || rule.getDayCloseMinutes() > 1440)
        {
            throw new ServiceException("下班后封存分钟必须在0到1440分钟之间");
        }
        if (rule.getAbsentMinutes() < rule.getLateMinutes() && rule.getAbsentMinutes() < rule.getEarlyMinutes())
        {
            throw new ServiceException("旷工容差不能同时小于迟到阈值和早退阈值");
        }
        if (rule.getMultiPunchStrategy() == null || rule.getMultiPunchStrategy().trim().isEmpty())
        {
            rule.setMultiPunchStrategy("EARLIEST_IN_LATEST_OUT");
        }
        if (!"EARLIEST_IN_LATEST_OUT".equals(rule.getMultiPunchStrategy()))
        {
            throw new ServiceException("当前仅支持“最早上班 + 最晚下班”策略");
        }
    }
}
