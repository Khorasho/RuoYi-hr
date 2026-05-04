package com.ruoyi.system.service.hr.impl;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.mapper.hr.HrScheduleMapper;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrScheduleService;

@Service
public class HrScheduleServiceImpl implements IHrScheduleService
{
    @Autowired
    private HrScheduleMapper scheduleMapper;

    @Autowired
    private SysUserMapper userMapper;

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
    @Transactional
    public int insertHrSchedule(HrSchedule schedule, boolean overwrite)
    {
        if (schedule.getUserId() != null && schedule.getWorkDate() != null)
        {
            LocalDate workDate = schedule.getWorkDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            if (overwrite)
            {
                scheduleMapper.deleteByUserAndDate(schedule.getUserId(), workDate);
            }
            else if (scheduleMapper.countByUserAndDate(schedule.getUserId(), workDate) > 0)
            {
                throw new ServiceException("保存失败：该员工在 " + workDate + " 已存在排班，请使用覆盖保存");
            }
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
    public HrSchedule selectByUserAndDate(Long userId, LocalDate workDate)
    {
        if (userId == null || workDate == null)
        {
            return null;
        }
        return scheduleMapper.selectByUserAndDate(userId, workDate);
    }

    @Override
    public List<HrSchedule> selectByShiftId(Long shiftId)
    {
        return scheduleMapper.selectByShiftId(shiftId);
    }

    @Override
    public int deleteByShiftAndUser(Long shiftId, Long userId)
    {
        return scheduleMapper.deleteByShiftAndUser(shiftId, userId);
    }

    @Override
    @Transactional
    public int generateMonthlySchedule(String month, Long deptId, Long userId, boolean overwrite, String operator)
    {
        YearMonth ym = YearMonth.parse(month);
        LocalDate monthStart = ym.atDay(1);
        LocalDate monthEnd = ym.atEndOfMonth();

        List<SysUser> users;
        if (userId != null)
        {
            SysUser one = userMapper.selectUserById(userId);
            if (one == null)
            {
                return 0;
            }
            if (deptId != null && !deptId.equals(one.getDeptId()))
            {
                return 0;
            }
            if (!"0".equals(one.getStatus()))
            {
                return 0;
            }
            users = java.util.Collections.singletonList(one);
        }
        else
        {
            SysUser query = new SysUser();
            query.setDeptId(deptId);
            query.setStatus("0");
            users = userMapper.selectUserList(query);
        }

        Map<Long, HrShift> shiftCache = new HashMap<>();
        int generated = 0;
        for (SysUser user : users)
        {
            Long defaultShiftId = scheduleMapper.selectLatestShiftIdBeforeDate(user.getUserId(), monthStart);
            if (defaultShiftId == null)
            {
                continue;
            }
            HrShift shift = shiftCache.computeIfAbsent(defaultShiftId, id -> shiftMapper.selectHrShiftById(id));
            if (shift == null || !"0".equals(shift.getStatus()))
            {
                continue;
            }

            String mask = normalizeWorkdayMask(shift.getWorkdayMask());
            Set<LocalDate> existingDates = overwrite
                ? new HashSet<>()
                : new HashSet<>(scheduleMapper.selectWorkDatesByUserAndRange(user.getUserId(), monthStart, monthEnd));

            for (int day = 1; day <= ym.lengthOfMonth(); day++)
            {
                LocalDate localDate = ym.atDay(day);
                if (overwrite)
                {
                    scheduleMapper.deleteByUserAndDate(user.getUserId(), localDate);
                }
                else if (existingDates.contains(localDate))
                {
                    continue;
                }

                boolean workday = isWorkday(mask, localDate);
                HrSchedule schedule = new HrSchedule();
                schedule.setUserId(user.getUserId());
                schedule.setDeptId(user.getDeptId());
                schedule.setWorkDate(Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant()));
                schedule.setShiftId(workday ? shift.getShiftId() : null);
                schedule.setRestType(workday ? "" : "REST");
                schedule.setScheduleRemark("月排班生成(" + month + ")");
                schedule.setCreateBy(operator);
                generated += scheduleMapper.insertHrSchedule(schedule);
                existingDates.add(localDate);
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
        int index = date.getDayOfWeek().getValue() - 1;
        return mask.charAt(index) == '1';
    }
}
