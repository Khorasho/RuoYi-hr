package com.ruoyi.system.service.hr.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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
        return ruleMapper.updateHrAttendanceRule(rule);
    }
}
