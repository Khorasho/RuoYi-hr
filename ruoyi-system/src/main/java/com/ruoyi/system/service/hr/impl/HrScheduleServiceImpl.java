package com.ruoyi.system.service.hr.impl;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.system.domain.hr.HrEmployee;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.mapper.hr.HrEmployeeMapper;
import com.ruoyi.system.mapper.hr.HrScheduleMapper;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrScheduleService;

@Service
public class HrScheduleServiceImpl implements IHrScheduleService
{
    @Autowired
    private HrScheduleMapper scheduleMapper;
    
    @Autowired
    private HrEmployeeMapper employeeMapper;
    
    @Autowired
    private HrShiftMapper shiftMapper;

    @Override
    public List<HrSchedule> selectHrScheduleList(HrSchedule schedule)
    {
        return scheduleMapper.selectHrScheduleList(schedule);
    }

    @Override
    public HrSchedule selectHrScheduleById(Long scheduleId)
    {
        return scheduleMapper.selectHrScheduleById(scheduleId);
    }

    @Override
    public int insertHrSchedule(HrSchedule schedule, boolean overwrite)
    {
        if (overwrite && schedule.getUserId() != null && schedule.getWorkDate() != null)
        {
            LocalDate workDate = schedule.getWorkDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            scheduleMapper.deleteByUserAndDate(schedule.getUserId(), workDate);
        }
        return scheduleMapper.insertHrSchedule(schedule);
    }

    @Override
    public int updateHrSchedule(HrSchedule schedule)
    {
        return scheduleMapper.updateHrSchedule(schedule);
    }

    @Override
    public int deleteHrScheduleByIds(String ids)
    {
        return scheduleMapper.deleteHrScheduleByIds(Convert.toLongArray(ids));
    }
    
    @Override
    public int generateMonthlySchedule(String month, Long deptId, Long userId, boolean overwrite, String operator)
    {
        YearMonth ym = YearMonth.parse(month);
        HrEmployee query = new HrEmployee();
        query.setDeptId(deptId);
        query.setUserId(userId);
        query.setWorkStatus("0");
        query.setAttendEnabled("1");
        List<HrEmployee> employees = employeeMapper.selectHrEmployeeList(query);
        int generated = 0;
        for (HrEmployee employee : employees)
        {
            if (employee.getDefaultShiftId() == null)
            {
                continue;
            }
            HrShift shift = shiftMapper.selectHrShiftById(employee.getDefaultShiftId());
            if (shift == null)
            {
                continue;
            }
            String mask = normalizeWorkdayMask(shift.getWorkdayMask());
            for (int day = 1; day <= ym.lengthOfMonth(); day++)
            {
                LocalDate localDate = ym.atDay(day);
                if (overwrite)
                {
                    scheduleMapper.deleteByUserAndDate(employee.getUserId(), localDate);
                }
                else if (scheduleMapper.countByUserAndDate(employee.getUserId(), localDate) > 0)
                {
                    continue;
                }
                boolean workday = isWorkday(mask, localDate);
                HrSchedule schedule = new HrSchedule();
                schedule.setUserId(employee.getUserId());
                schedule.setDeptId(employee.getDeptId());
                schedule.setWorkDate(Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant()));
                schedule.setShiftId(workday ? shift.getShiftId() : null);
                schedule.setRestType(workday ? "" : "REST");
                schedule.setScheduleRemark("月排班生成(" + month + ")");
                schedule.setCreateBy(operator);
                generated += scheduleMapper.insertHrSchedule(schedule);
            }
        }
        return generated;
    }
    
    private String normalizeWorkdayMask(String mask)
    {
        if (mask == null)
        {
            return "1111100";
        }
        String cleaned = mask.replaceAll("[^01]", "");
        if (cleaned.length() == 7)
        {
            return cleaned;
        }
        return "1111100";
    }
    
    private boolean isWorkday(String mask, LocalDate date)
    {
        int index = date.getDayOfWeek().getValue() - 1; // Monday=0 ... Sunday=6
        return mask.charAt(index) == '1';
    }
}
