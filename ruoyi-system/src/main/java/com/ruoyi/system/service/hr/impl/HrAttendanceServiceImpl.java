package com.ruoyi.system.service.hr.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.domain.hr.HrAttendanceException;
import com.ruoyi.system.domain.hr.HrAttendanceRecord;
import com.ruoyi.system.domain.hr.HrAttendanceResult;
import com.ruoyi.system.domain.hr.HrAttendanceRule;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.mapper.hr.HrAttendanceRecordMapper;
import com.ruoyi.system.mapper.hr.HrAttendanceResultMapper;
import com.ruoyi.system.mapper.hr.HrAttendanceRuleMapper;
import com.ruoyi.system.mapper.hr.HrScheduleMapper;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrAttendanceService;

@Service
public class HrAttendanceServiceImpl implements IHrAttendanceService
{
    @Autowired
    private HrScheduleMapper scheduleMapper;

    @Autowired
    private HrShiftMapper shiftMapper;

    @Autowired
    private HrAttendanceRecordMapper recordMapper;

    @Autowired
    private HrAttendanceResultMapper resultMapper;

    @Autowired
    private HrAttendanceRuleMapper ruleMapper;

    @Override
    @Transactional
    public int recalculateDay(LocalDate workDate, String operator)
    {
        resultMapper.deleteByDate(workDate);
        resultMapper.deleteExceptionsByDate(workDate);

        HrAttendanceRule rule = ruleMapper.selectActiveRule();
        if (rule == null)
        {
            rule = new HrAttendanceRule();
            rule.setLateMinutes(0);
            rule.setEarlyMinutes(0);
            rule.setAbsentMinutes(120);
        }

        List<HrSchedule> schedules = scheduleMapper.selectByDate(workDate);
        int rows = 0;
        for (HrSchedule schedule : schedules)
        {
            if ("REST".equalsIgnoreCase(schedule.getRestType()))
            {
                continue;
            }
            HrShift shift = shiftMapper.selectHrShiftById(schedule.getShiftId());
            if (shift == null || shift.getExpectedStartTime() == null || shift.getExpectedEndTime() == null)
            {
                continue;
            }
            rows += buildResult(workDate, schedule, shift, rule, operator);
        }
        return rows;
    }

    @Override
    @Transactional
    public int recalculateMonth(String month, String operator)
    {
        YearMonth ym = YearMonth.parse(month);
        int total = 0;
        for (int i = 1; i <= ym.lengthOfMonth(); i++)
        {
            total += recalculateDay(LocalDate.of(ym.getYear(), ym.getMonth(), i), operator);
        }
        return total;
    }

    @Override
    public List<HrAttendanceResult> selectAttendanceResultList(HrAttendanceResult query)
    {
        return resultMapper.selectHrAttendanceResultList(query);
    }

    @Override
    public List<Map<String, Object>> selectMonthDeptSummary(String month, Long deptId, Long userId)
    {
        return resultMapper.selectMonthDeptSummary(month, deptId, userId);
    }

    @Override
    public List<Map<String, Object>> selectMonthUserSummary(String month, Long deptId, Long userId)
    {
        return resultMapper.selectMonthUserSummary(month, deptId, userId);
    }

    private int buildResult(LocalDate workDate, HrSchedule schedule, HrShift shift, HrAttendanceRule rule, String operator)
    {
        LocalDateTime expectIn = LocalDateTime.of(workDate, shift.getExpectedStartTime());
        LocalDateTime expectOut = LocalDateTime.of(workDate, shift.getExpectedEndTime());
        if (shift.getExpectedEndTime().isBefore(shift.getExpectedStartTime()))
        {
            expectOut = expectOut.plusDays(1);
        }
        if ("1".equals(shift.getSummerExtendEnabled()) && shift.getSummerExtendMinutes() != null)
        {
            expectOut = expectOut.plusMinutes(shift.getSummerExtendMinutes());
        }

        LocalDateTime queryBegin = LocalDateTime.of(workDate, LocalTime.MIN);
        LocalDateTime queryEnd = LocalDateTime.of(workDate.plusDays(1), LocalTime.MAX);
        List<HrAttendanceRecord> records = recordMapper.selectByUserAndRange(schedule.getUserId(), queryBegin, queryEnd);
        List<LocalDateTime> punches = new ArrayList<>();
        for (HrAttendanceRecord record : records)
        {
            punches.add(record.getPunchTime());
        }

        LocalDateTime actualIn = punches.isEmpty() ? null : punches.get(0);
        LocalDateTime actualOut = punches.isEmpty() ? null : punches.get(punches.size() - 1);

        HrAttendanceResult result = new HrAttendanceResult();
        result.setUserId(schedule.getUserId());
        result.setWorkDate(workDate);
        result.setExpectedInTime(expectIn);
        result.setExpectedOutTime(expectOut);
        result.setActualInTime(actualIn);
        result.setActualOutTime(actualOut);
        result.setExpectedMinutes((int) ChronoUnit.MINUTES.between(expectIn, expectOut));
        result.setCreateBy(operator);

        boolean missCard = actualIn == null || actualOut == null;
        boolean absent = missCard;
        boolean late = false;
        boolean early = false;

        if (!missCard)
        {
            late = actualIn.isAfter(expectIn.plusMinutes(rule.getLateMinutes() == null ? 0 : rule.getLateMinutes()));
            early = actualOut.isBefore(expectOut.minusMinutes(rule.getEarlyMinutes() == null ? 0 : rule.getEarlyMinutes()));
            int actualMinutes = (int) ChronoUnit.MINUTES.between(actualIn, actualOut);
            result.setActualMinutes(Math.max(actualMinutes, 0));
            int absentMinutes = rule.getAbsentMinutes() == null ? 120 : rule.getAbsentMinutes();
            absent = actualMinutes < Math.max(0, result.getExpectedMinutes() - absentMinutes);
        }
        else
        {
            result.setActualMinutes(0);
        }

        result.setMissCardFlag(missCard ? "1" : "0");
        result.setLateFlag(late ? "1" : "0");
        result.setEarlyFlag(early ? "1" : "0");
        result.setAbsentFlag(absent ? "1" : "0");

        int rows = resultMapper.insertHrAttendanceResult(result);

        if (late)
        {
            saveException(schedule.getUserId(), workDate, "LATE", "迟到", operator);
        }
        if (early)
        {
            saveException(schedule.getUserId(), workDate, "EARLY", "早退", operator);
        }
        if (missCard)
        {
            saveException(schedule.getUserId(), workDate, "MISS_CARD", "缺卡", operator);
        }
        if (absent)
        {
            saveException(schedule.getUserId(), workDate, "ABSENT", "旷工", operator);
        }
        return rows;
    }

    private void saveException(Long userId, LocalDate workDate, String type, String detail, String operator)
    {
        HrAttendanceException exception = new HrAttendanceException();
        exception.setUserId(userId);
        exception.setWorkDate(workDate);
        exception.setExceptionType(type);
        exception.setExceptionDetail(detail);
        exception.setCreateBy(operator);
        resultMapper.insertHrAttendanceException(exception);
    }
}
