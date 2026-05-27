package com.ruoyi.system.service.hr.impl;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.hr.HrEmployeeSetting;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.mapper.hr.HrEmployeeSettingMapper;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrEmployeeSettingService;

@Service
public class HrEmployeeSettingServiceImpl implements IHrEmployeeSettingService
{
    @Autowired
    private HrEmployeeSettingMapper employeeSettingMapper;

    @Autowired
    private HrShiftMapper shiftMapper;

    @Override
    public List<HrEmployeeSetting> selectHrEmployeeSettingList(HrEmployeeSetting query)
    {
        return employeeSettingMapper.selectHrEmployeeSettingList(query);
    }

    @Override
    public HrEmployeeSetting selectHrEmployeeSettingByUserId(Long userId)
    {
        return employeeSettingMapper.selectHrEmployeeSettingByUserId(userId);
    }

    @Override
    public int countConfiguredAttendanceUsers()
    {
        HrEmployeeSetting query = new HrEmployeeSetting();
        query.setAttendanceEnabled("1");
        return (int) employeeSettingMapper.selectHrEmployeeSettingList(query).stream()
            .filter(item -> "0".equals(item.getUserStatus()))
            .filter(item -> item.getEntryDate() != null)
            .filter(item -> item.getDefaultShiftId() != null)
            .count();
    }

    @Override
    @Transactional
    public int saveOnboardingInfo(Long userId, Date entryDate, String operator)
    {
        if (userId == null)
        {
            throw new ServiceException("缺少员工信息");
        }
        if (entryDate == null)
        {
            throw new ServiceException("请选择入职日期");
        }

        HrEmployeeSetting setting = employeeSettingMapper.selectHrEmployeeSettingByUserId(userId);
        if (setting == null)
        {
            setting = new HrEmployeeSetting();
            setting.setUserId(userId);
            setting.setEntryDate(entryDate);
            setting.setAttendanceEnabled("1");
            setting.setCreateBy(operator);
            return employeeSettingMapper.insertHrEmployeeSetting(setting);
        }

        setting.setEntryDate(entryDate);
        if (setting.getAttendanceEnabled() == null || setting.getAttendanceEnabled().isEmpty())
        {
            setting.setAttendanceEnabled("1");
        }
        setting.setUpdateBy(operator);
        return employeeSettingMapper.updateHrEmployeeSetting(setting);
    }

    @Override
    @Transactional
    public int saveDepartureInfo(Long userId, Date leaveDate, String remark, String operator)
    {
        if (userId == null)
        {
            throw new ServiceException("缺少员工信息");
        }
        if (leaveDate == null)
        {
            throw new ServiceException("请选择离职日期");
        }

        HrEmployeeSetting setting = employeeSettingMapper.selectHrEmployeeSettingByUserId(userId);
        if (setting == null)
        {
            setting = new HrEmployeeSetting();
            setting.setUserId(userId);
            setting.setEntryDate(leaveDate);
            setting.setAttendanceEnabled("0");
            setting.setLeaveDate(leaveDate);
            setting.setRemark(remark);
            setting.setCreateBy(operator);
            return employeeSettingMapper.insertHrEmployeeSetting(setting);
        }

        Date entryDate = setting.getEntryDate() == null ? leaveDate : setting.getEntryDate();
        if (leaveDate.before(entryDate))
        {
            throw new ServiceException("离职日期不能早于入职日期");
        }
        setting.setEntryDate(entryDate);
        setting.setLeaveDate(leaveDate);
        setting.setAttendanceEnabled("0");
        if (remark != null)
        {
            setting.setRemark(remark);
        }
        setting.setUpdateBy(operator);
        return employeeSettingMapper.updateHrEmployeeSetting(setting);
    }

    @Override
    @Transactional
    public int saveHrEmployeeSetting(HrEmployeeSetting setting, String operator)
    {
        if (setting.getUserId() == null)
        {
            throw new ServiceException("缺少员工信息");
        }
        validateSetting(setting);

        if (employeeSettingMapper.countHrEmployeeSettingByUserId(setting.getUserId()) == 0)
        {
            setting.setCreateBy(operator);
            return employeeSettingMapper.insertHrEmployeeSetting(setting);
        }

        setting.setUpdateBy(operator);
        return employeeSettingMapper.updateHrEmployeeSetting(setting);
    }

    @Override
    @Transactional
    public int batchSaveHrEmployeeSetting(Long[] userIds, HrEmployeeSetting setting, String operator)
    {
        if (userIds == null || userIds.length == 0)
        {
            throw new ServiceException("请先选择员工");
        }
        validateBatchSetting(setting);
        List<Long> targetIds = Arrays.stream(userIds)
            .filter(Objects::nonNull)
            .distinct()
            .collect(Collectors.toList());
        if (targetIds.isEmpty())
        {
            throw new ServiceException("请先选择员工");
        }
        int rows = 0;
        for (Long userId : targetIds)
        {
            HrEmployeeSetting saveItem = employeeSettingMapper.selectHrEmployeeSettingByUserId(userId);
            if (saveItem == null)
            {
                saveItem = new HrEmployeeSetting();
            }
            if (saveItem.getEntryDate() == null)
            {
                throw new ServiceException("员工ID " + userId + " 缺少入职日期，请先在用户管理中办理入职");
            }
            saveItem.setUserId(userId);
            saveItem.setEntryDate(saveItem.getEntryDate());
            saveItem.setRotationAnchorDate(setting.getRotationAnchorDate());
            saveItem.setDefaultShiftId(setting.getDefaultShiftId());
            saveItem.setAttendanceEnabled(setting.getAttendanceEnabled());
            saveItem.setRemark(setting.getRemark());
            if (employeeSettingMapper.countHrEmployeeSettingByUserId(userId) == 0)
            {
                saveItem.setCreateBy(operator);
                rows += employeeSettingMapper.insertHrEmployeeSetting(saveItem);
            }
            else
            {
                saveItem.setUpdateBy(operator);
                rows += employeeSettingMapper.updateHrEmployeeSetting(saveItem);
            }
        }
        return rows;
    }

    private void validateBatchSetting(HrEmployeeSetting setting)
    {
        if (setting.getDefaultShiftId() == null)
        {
            throw new ServiceException("请选择默认班次");
        }

        HrShift shift = shiftMapper.selectHrShiftById(setting.getDefaultShiftId());
        if (shift == null || !"0".equals(shift.getStatus()))
        {
            throw new ServiceException("默认班次不存在或已停用");
        }
        if ("1".equals(shift.getIsRestShift()))
        {
            throw new ServiceException("默认班次不能配置为休息班次");
        }
        if (setting.getAttendanceEnabled() == null || setting.getAttendanceEnabled().isEmpty())
        {
            setting.setAttendanceEnabled("1");
        }
    }

    private void validateSetting(HrEmployeeSetting setting)
    {
        if (setting.getEntryDate() == null)
        {
            throw new ServiceException("请选择入职日期");
        }
        if (setting.getDefaultShiftId() == null)
        {
            throw new ServiceException("请选择默认班次");
        }
        if (setting.getLeaveDate() != null && setting.getLeaveDate().before(setting.getEntryDate()))
        {
            throw new ServiceException("离职日期不能早于入职日期");
        }

        HrShift shift = shiftMapper.selectHrShiftById(setting.getDefaultShiftId());
        if (shift == null || !"0".equals(shift.getStatus()))
        {
            throw new ServiceException("默认班次不存在或已停用");
        }
        if ("1".equals(shift.getIsRestShift()))
        {
            throw new ServiceException("默认班次不能配置为休息班次");
        }
        if (setting.getAttendanceEnabled() == null || setting.getAttendanceEnabled().isEmpty())
        {
            setting.setAttendanceEnabled("1");
        }
    }
}
