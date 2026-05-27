package com.ruoyi.system.service.hr.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.domain.hr.HrAttendanceException;
import com.ruoyi.system.domain.hr.HrAttendanceRecord;
import com.ruoyi.system.domain.hr.HrAttendanceReportQuery;
import com.ruoyi.system.domain.hr.HrDeptAttendanceReport;
import com.ruoyi.system.domain.hr.HrAttendanceResult;
import com.ruoyi.system.domain.hr.HrAttendanceResultSegment;
import com.ruoyi.system.domain.hr.HrAttendanceRule;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;
import com.ruoyi.system.domain.hr.HrUserAttendanceReport;
import com.ruoyi.system.mapper.hr.HrAttendanceRecordMapper;
import com.ruoyi.system.mapper.hr.HrAttendanceResultMapper;
import com.ruoyi.system.mapper.hr.HrAttendanceResultSegmentMapper;
import com.ruoyi.system.mapper.hr.HrAttendanceRuleMapper;
import com.ruoyi.system.mapper.hr.HrScheduleMapper;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrAttendanceService;

@Service
public class HrAttendanceServiceImpl implements IHrAttendanceService
{
    private static final String SOURCE_SCHEDULE = "SCHEDULE";
    private static final String SOURCE_DEMO = "DEMO";

    @Autowired
    private HrScheduleMapper scheduleMapper;

    @Autowired
    private HrShiftMapper shiftMapper;

    @Autowired
    private HrAttendanceRecordMapper recordMapper;

    @Autowired
    private HrAttendanceResultMapper resultMapper;

    @Autowired
    private HrAttendanceResultSegmentMapper resultSegmentMapper;

    @Autowired
    private HrAttendanceRuleMapper ruleMapper;

    @Override
    @Transactional
    public int generateDateRange(LocalDate beginDate, LocalDate endDate, String operator)
    {
        resultSegmentMapper.deleteByDateRange(beginDate, endDate);
        resultMapper.deleteByDateRange(beginDate, endDate);
        resultMapper.deleteExceptionsByDateRange(beginDate, endDate);

        HrAttendanceRule rule = loadRule();
        List<HrSchedule> schedules = scheduleMapper.selectByDateRange(beginDate, endDate);
        int rows = 0;
        for (HrSchedule schedule : schedules)
        {
            HrShift shift = shiftMapper.selectHrShiftById(schedule.getShiftId());
            if (shift == null)
            {
                continue;
            }
            rows += buildResult(schedule, shift, rule, operator);
        }
        return rows;
    }

    @Override
    @Transactional
    public int generateMonthly(String month, String operator)
    {
        YearMonth ym = YearMonth.parse(month);
        return generateDateRange(ym.atDay(1), ym.atEndOfMonth(), operator);
    }

    @Override
    @Transactional
    public int syncFutureAttendance(int days, String operator)
    {
        int futureDays = days <= 0 ? 7 : days;
        LocalDate beginDate = LocalDate.now();
        LocalDate endDate = beginDate.plusDays(futureDays - 1L);
        return generateDateRange(beginDate, endDate, operator);
    }

    @Override
    @Transactional
    public int recalculateDay(LocalDate workDate, String operator)
    {
        return generateDateRange(workDate, workDate, operator);
    }

    @Override
    @Transactional
    public int recalculateMonth(String month, String operator)
    {
        return generateMonthly(month, operator);
    }

    @Override
    @Transactional
    public int generateDemoPunches(String month, String operator)
    {
        YearMonth ym = YearMonth.parse(month);
        LocalDate beginDate = ym.atDay(1);
        LocalDate endDate = ym.atDay(Math.min(12, ym.lengthOfMonth()));
        recordMapper.deleteAllRecords();

        List<HrSchedule> schedules = scheduleMapper.selectByDateRange(beginDate, endDate);
        int rows = 0;
        for (HrSchedule schedule : schedules)
        {
            HrShift shift = shiftMapper.selectHrShiftById(schedule.getShiftId());
            if (shift == null || "1".equals(shift.getIsRestShift()) || "REST".equalsIgnoreCase(schedule.getRestType()))
            {
                continue;
            }
            List<HrShiftPeriod> periods = shiftMapper.selectPeriodsByShiftId(schedule.getShiftId());
            if (periods == null || periods.isEmpty())
            {
                continue;
            }
            rows += createDemoPunches(schedule, periods, operator);
        }

        generateDateRange(beginDate, endDate, operator);
        return rows;
    }

    @Override
    public List<HrAttendanceResult> selectAttendanceResultList(HrAttendanceResult query)
    {
        return resultMapper.selectHrAttendanceResultList(query);
    }

    @Override
    public HrAttendanceResult selectAttendanceResultById(Long resultId)
    {
        return resultMapper.selectByResultId(resultId);
    }

    @Override
    public List<HrAttendanceResultSegment> selectAttendanceResultSegments(Long resultId)
    {
        return resultSegmentMapper.selectByResultId(resultId);
    }

    @Override
    public List<HrAttendanceRecord> selectAttendancePunchRecords(Long userId, LocalDate workDate)
    {
        return queryPunchRecords(userId, workDate);
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

    @Override
    public List<Map<String, Object>> selectYearDeptSummary(String year, Long deptId, Long userId)
    {
        return resultMapper.selectYearDeptSummary(year, deptId, userId);
    }

    @Override
    public List<Map<String, Object>> selectYearUserSummary(String year, Long deptId, Long userId)
    {
        return resultMapper.selectYearUserSummary(year, deptId, userId);
    }

    @Override
    public List<HrDeptAttendanceReport> selectMonthDeptReport(HrAttendanceReportQuery query)
    {
        return resultMapper.selectMonthDeptReport(query);
    }

    @Override
    public List<HrUserAttendanceReport> selectMonthUserReport(HrAttendanceReportQuery query)
    {
        return resultMapper.selectMonthUserReport(query);
    }

    @Override
    public List<HrDeptAttendanceReport> selectYearDeptReport(HrAttendanceReportQuery query)
    {
        return resultMapper.selectYearDeptReport(query);
    }

    @Override
    public List<HrUserAttendanceReport> selectYearUserReport(HrAttendanceReportQuery query)
    {
        return resultMapper.selectYearUserReport(query);
    }

    private HrAttendanceRule loadRule()
    {
        HrAttendanceRule rule = ruleMapper.selectActiveRule();
        if (rule == null)
        {
            rule = new HrAttendanceRule();
            rule.setRuleId(1L);
        }
        if (rule.getLateMinutes() == null)
        {
            rule.setLateMinutes(10);
        }
        if (rule.getEarlyMinutes() == null)
        {
            rule.setEarlyMinutes(10);
        }
        if (rule.getAbsentMinutes() == null)
        {
            rule.setAbsentMinutes(120);
        }
        if (rule.getDayCloseMinutes() == null)
        {
            rule.setDayCloseMinutes(120);
        }
        return rule;
    }

    private int buildResult(HrSchedule schedule, HrShift shift, HrAttendanceRule rule, String operator)
    {
        LocalDate workDate = schedule.getWorkDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        HrAttendanceResult result = new HrAttendanceResult();
        result.setScheduleId(schedule.getScheduleId());
        result.setUserId(schedule.getUserId());
        result.setLoginName(schedule.getLoginName());
        result.setUserName(schedule.getUserName());
        result.setDeptId(schedule.getDeptId());
        result.setDeptName(schedule.getDeptName());
        result.setWorkDate(workDate);
        result.setShiftId(schedule.getShiftId());
        result.setShiftName(schedule.getShiftName());
        result.setRestType(schedule.getRestType());
        result.setCreateBy(operator);
        result.setDataSource(SOURCE_SCHEDULE);
        result.setRemark(schedule.getScheduleRemark());

        if ("REST".equalsIgnoreCase(schedule.getRestType()) || "1".equals(shift.getIsRestShift()))
        {
            List<HrAttendanceRecord> punchRecords = queryPunchRecords(schedule.getUserId(), workDate);
            fillRestDayResult(result, punchRecords);
            return resultMapper.insertHrAttendanceResult(result);
        }

        List<HrShiftPeriod> periods = shiftMapper.selectPeriodsByShiftId(schedule.getShiftId());
        if (periods == null || periods.isEmpty())
        {
            List<HrAttendanceRecord> punchRecords = queryPunchRecords(schedule.getUserId(), workDate);
            fillPendingResult(result, punchRecords);
            result.setRemark(appendRemark(result.getRemark(), "班次未配置时段"));
            return resultMapper.insertHrAttendanceResult(result);
        }

        List<SegmentWindow> segmentWindows = buildSegmentWindows(workDate, periods);
        List<HrAttendanceRecord> punchRecords = queryPunchRecords(schedule.getUserId(), workDate, segmentWindows);
        Set<Long> usedRecordIds = new LinkedHashSet<>();
        List<HrAttendanceResultSegment> segmentResults = buildSegmentResults(schedule, segmentWindows, punchRecords, usedRecordIds, true, rule, operator);
        fillAggregateResult(result, segmentResults, punchRecords, usedRecordIds, true);

        int rows = resultMapper.insertHrAttendanceResult(result);
        for (HrAttendanceResultSegment segment : segmentResults)
        {
            segment.setResultId(result.getResultId());
            resultSegmentMapper.insertHrAttendanceResultSegment(segment);
        }
        saveDayExceptions(result, operator);
        return rows;
    }

    private List<HrAttendanceResultSegment> buildSegmentResults(HrSchedule schedule, List<SegmentWindow> segmentWindows,
        List<HrAttendanceRecord> punchRecords, Set<Long> usedRecordIds, boolean dayClosed, HrAttendanceRule rule, String operator)
    {
        List<HrAttendanceResultSegment> results = new ArrayList<>();
        List<PunchSlot> slots = new ArrayList<>();
        for (SegmentWindow window : segmentWindows)
        {
            HrAttendanceResultSegment segment = new HrAttendanceResultSegment();
            segment.setScheduleId(schedule.getScheduleId());
            segment.setUserId(schedule.getUserId());
            segment.setWorkDate(window.workDate);
            segment.setShiftId(schedule.getShiftId());
            segment.setSegmentNo(window.period.getPeriodNo());
            segment.setSegmentName(window.period.getSegmentName());
            segment.setPlanInTime(window.planInTime);
            segment.setPlanOutTime(window.planOutTime);
            segment.setValidBeginTime(window.validBeginTime);
            segment.setValidEndTime(window.validEndTime);
            segment.setNeedInPunch(defaultFlag(window.period.getNeedInPunch(), "1"));
            segment.setNeedOutPunch(defaultFlag(window.period.getNeedOutPunch(), "1"));
            segment.setCreateBy(operator);
            results.add(segment);

            if ("1".equals(segment.getNeedInPunch()))
            {
                slots.add(new PunchSlot(segment, "IN", segment.getPlanInTime()));
            }
            if ("1".equals(segment.getNeedOutPunch()))
            {
                slots.add(new PunchSlot(segment, "OUT", segment.getPlanOutTime()));
            }
        }

        for (HrAttendanceRecord record : punchRecords)
        {
            PunchSlot slot = findNearestSlot(slots, record.getPunchTime());
            if (slot == null)
            {
                continue;
            }
            slot.record = record;
            if (record.getRecordId() != null)
            {
                usedRecordIds.add(record.getRecordId());
            }
            if ("IN".equals(slot.punchKind))
            {
                slot.segment.setActualInTime(record.getPunchTime());
            }
            else
            {
                slot.segment.setActualOutTime(record.getPunchTime());
            }
        }

        for (HrAttendanceResultSegment segment : results)
        {
            segment.setPunchCount(countSegmentPunches(segment));
            classifyClosedSegment(segment, rule);
        }
        return results;
    }

    private void classifyClosedSegment(HrAttendanceResultSegment segment, HrAttendanceRule rule)
    {
        boolean needIn = "1".equals(defaultFlag(segment.getNeedInPunch(), "1"));
        boolean needOut = "1".equals(defaultFlag(segment.getNeedOutPunch(), "1"));
        boolean late = false;
        boolean early = false;
        boolean missCard = false;
        String status;

        if (!needIn && !needOut)
        {
            status = "NORMAL";
            segment.setWorkMinutes(calculatePlanMinutes(segment));
        }
        else if ((needIn && segment.getActualInTime() == null) || (needOut && segment.getActualOutTime() == null))
        {
            missCard = true;
            status = "MISS_CARD";
            segment.setWorkMinutes(0);
            segment.setRemark(safeInt(segment.getPunchCount(), 0) == 0 ? "该班段没有打卡记录" : "该班段存在缺卡");
        }
        else
        {
            late = needIn && segment.getActualInTime() != null
                && segment.getActualInTime().isAfter(segment.getPlanInTime().plusMinutes(safeInt(rule.getLateMinutes(), 10)));
            early = needOut && segment.getActualOutTime() != null
                && segment.getActualOutTime().isBefore(segment.getPlanOutTime().minusMinutes(safeInt(rule.getEarlyMinutes(), 10)));
            segment.setWorkMinutes(calculateSegmentMinutes(segment));
            if (late && early)
            {
                status = "LATE_EARLY";
            }
            else if (late)
            {
                status = "LATE";
            }
            else if (early)
            {
                status = "EARLY";
            }
            else
            {
                status = "NORMAL";
            }
        }

        segment.setSegmentStatus(status);
        segment.setLateFlag(late ? "1" : "0");
        segment.setEarlyFlag(early ? "1" : "0");
        segment.setMissCardFlag(missCard ? "1" : "0");
        segment.setAbsentFlag("0");
        if (segment.getWorkMinutes() == null)
        {
            segment.setWorkMinutes(0);
        }
    }

    private void fillAggregateResult(HrAttendanceResult result, List<HrAttendanceResultSegment> segmentResults,
        List<HrAttendanceRecord> punchRecords, Set<Long> usedRecordIds, boolean dayClosed)
    {
        result.setPunchCount(punchRecords.size());
        result.setExpectedMinutes(0);
        result.setActualMinutes(0);
        result.setLateFlag("0");
        result.setEarlyFlag("0");
        result.setMissCardFlag("0");
        result.setAbsentFlag("0");

        LocalDateTime expectedIn = null;
        LocalDateTime expectedOut = null;
        LocalDateTime actualIn = null;
        LocalDateTime actualOut = null;
        boolean hasLate = false;
        boolean hasEarly = false;
        boolean hasMissCard = false;
        Set<String> exceptions = new LinkedHashSet<>();
        List<String> summaryList = new ArrayList<>();

        for (HrAttendanceResultSegment segment : segmentResults)
        {
            result.setExpectedMinutes(safeInt(result.getExpectedMinutes(), 0) + calculatePlanMinutes(segment));
            result.setActualMinutes(safeInt(result.getActualMinutes(), 0) + safeInt(segment.getWorkMinutes(), 0));
            expectedIn = minDateTime(expectedIn, segment.getPlanInTime());
            expectedOut = maxDateTime(expectedOut, segment.getPlanOutTime());
            actualIn = minDateTime(actualIn, segment.getActualInTime());
            actualOut = maxDateTime(actualOut, segment.getActualOutTime());
            hasLate = hasLate || "1".equals(segment.getLateFlag());
            hasEarly = hasEarly || "1".equals(segment.getEarlyFlag());
            hasMissCard = hasMissCard || "1".equals(segment.getMissCardFlag());
            if ("LATE".equals(segment.getSegmentStatus()) || "LATE_EARLY".equals(segment.getSegmentStatus()))
            {
                exceptions.add("LATE");
            }
            if ("EARLY".equals(segment.getSegmentStatus()) || "LATE_EARLY".equals(segment.getSegmentStatus()))
            {
                exceptions.add("EARLY");
            }
            if ("MISS_CARD".equals(segment.getSegmentStatus()))
            {
                exceptions.add("MISS_CARD");
            }
            summaryList.add(buildSegmentSummary(segment));
        }

        result.setExpectedInTime(expectedIn);
        result.setExpectedOutTime(expectedOut);
        result.setActualInTime(actualIn);
        result.setActualOutTime(actualOut);
        result.setSegmentSummary(String.join("; ", summaryList));

        int unmatchedCount = 0;
        for (HrAttendanceRecord record : punchRecords)
        {
            if (record.getRecordId() == null || !usedRecordIds.contains(record.getRecordId()))
            {
                unmatchedCount++;
            }
        }
        if (unmatchedCount > 0)
        {
            result.setRemark(appendRemark(result.getRemark(), "存在未匹配打卡 " + unmatchedCount + " 次"));
        }

        result.setLateFlag(hasLate ? "1" : "0");
        result.setEarlyFlag(hasEarly ? "1" : "0");
        result.setMissCardFlag(hasMissCard ? "1" : "0");
        result.setAbsentFlag("0");
        result.setExceptionType(exceptions.isEmpty() ? null : String.join(",", exceptions));

        if (punchRecords.isEmpty())
        {
            result.setAttendanceStatus("MISS_CARD");
            result.setExceptionType("MISS_CARD");
            result.setMissCardFlag("1");
            return;
        }

        if (hasMissCard)
        {
            result.setAttendanceStatus("MISS_CARD");
        }
        else if (hasLate && hasEarly)
        {
            result.setAttendanceStatus("LATE_EARLY");
        }
        else if (hasLate)
        {
            result.setAttendanceStatus("LATE");
        }
        else if (hasEarly)
        {
            result.setAttendanceStatus("EARLY");
        }
        else
        {
            result.setAttendanceStatus("NORMAL");
        }
    }

    private void saveDayExceptions(HrAttendanceResult result, String operator)
    {
        if (result.getExceptionType() == null || result.getExceptionType().trim().isEmpty())
        {
            return;
        }
        String[] types = result.getExceptionType().split(",");
        for (String type : types)
        {
            String detail = translateException(type);
            if (detail == null)
            {
                continue;
            }
            saveException(result.getUserId(), result.getWorkDate(), type, detail, operator);
        }
    }

    private void fillRestDayResult(HrAttendanceResult result, List<HrAttendanceRecord> punches)
    {
        LocalDateTime actualIn = punches.isEmpty() ? null : punches.get(0).getPunchTime();
        LocalDateTime actualOut = punches.isEmpty() ? null : punches.get(punches.size() - 1).getPunchTime();
        result.setAttendanceStatus("REST");
        result.setExpectedMinutes(0);
        result.setActualMinutes(calculateActualMinutes(actualIn, actualOut));
        result.setPunchCount(punches.size());
        result.setActualInTime(actualIn);
        result.setActualOutTime(actualOut);
        result.setLateFlag("0");
        result.setEarlyFlag("0");
        result.setMissCardFlag("0");
        result.setAbsentFlag("0");
        result.setSegmentSummary("休息日");
        if (!punches.isEmpty())
        {
            result.setRemark(appendRemark(result.getRemark(), "休息日存在打卡记录"));
        }
    }

    private void fillPendingResult(HrAttendanceResult result, List<HrAttendanceRecord> punches)
    {
        LocalDateTime actualIn = punches.isEmpty() ? null : punches.get(0).getPunchTime();
        LocalDateTime actualOut = punches.isEmpty() ? null : punches.get(punches.size() - 1).getPunchTime();
        result.setAttendanceStatus(punches.isEmpty() ? "MISS_CARD" : "NORMAL");
        result.setExceptionType(punches.isEmpty() ? "MISS_CARD" : null);
        result.setActualInTime(actualIn);
        result.setActualOutTime(actualOut);
        result.setPunchCount(punches.size());
        result.setActualMinutes(calculateActualMinutes(actualIn, actualOut));
        result.setLateFlag("0");
        result.setEarlyFlag("0");
        result.setMissCardFlag(punches.isEmpty() ? "1" : "0");
        result.setAbsentFlag("0");
    }

    private boolean isDayClosed(LocalDate workDate, List<SegmentWindow> segmentWindows, HrAttendanceRule rule)
    {
        if (workDate.isBefore(LocalDate.now()))
        {
            return true;
        }
        LocalDateTime lastPlanOut = null;
        for (SegmentWindow window : segmentWindows)
        {
            lastPlanOut = maxDateTime(lastPlanOut, window.planOutTime);
        }
        if (lastPlanOut == null)
        {
            return false;
        }
        int closeMinutes = Math.max(0, safeInt(rule.getDayCloseMinutes(), 120));
        LocalDateTime closeTime = lastPlanOut.plusMinutes(closeMinutes);
        return !LocalDateTime.now().isBefore(closeTime);
    }

    private List<HrAttendanceRecord> queryPunchRecords(Long userId, LocalDate workDate)
    {
        LocalDateTime begin = workDate.atStartOfDay();
        LocalDateTime end = workDate.plusDays(1).atStartOfDay().minusNanos(1);
        return recordMapper.selectByUserAndRange(userId, begin, end);
    }

    private List<HrAttendanceRecord> queryPunchRecords(Long userId, LocalDate workDate, List<SegmentWindow> segmentWindows)
    {
        if (segmentWindows == null || segmentWindows.isEmpty())
        {
            return queryPunchRecords(userId, workDate);
        }
        LocalDateTime begin = null;
        LocalDateTime end = null;
        for (SegmentWindow window : segmentWindows)
        {
            begin = minDateTime(begin, minDateTime(window.planInTime, window.validBeginTime));
            end = maxDateTime(end, maxDateTime(window.planOutTime, window.validEndTime));
        }
        if (begin == null || end == null)
        {
            return queryPunchRecords(userId, workDate);
        }
        return recordMapper.selectByUserAndRange(userId, begin, end);
    }

    private List<SegmentWindow> buildSegmentWindows(LocalDate workDate, List<HrShiftPeriod> periods)
    {
        List<SegmentWindow> windows = new ArrayList<>();
        for (HrShiftPeriod period : periods)
        {
            SegmentWindow window = new SegmentWindow();
            window.workDate = workDate;
            window.period = period;
            window.planInTime = LocalDateTime.of(workDate, period.getStartTime());
            window.planOutTime = LocalDateTime.of(workDate, period.getEndTime());
            if ("1".equals(defaultFlag(period.getCrossDay(), "0")) || !period.getEndTime().isAfter(period.getStartTime()))
            {
                window.planOutTime = window.planOutTime.plusDays(1);
            }
            windows.add(window);
        }

        for (int i = 0; i < windows.size(); i++)
        {
            SegmentWindow current = windows.get(i);
            SegmentWindow previous = i > 0 ? windows.get(i - 1) : null;
            SegmentWindow next = i < windows.size() - 1 ? windows.get(i + 1) : null;

            if (hasCustomValidWindow(current.period))
            {
                LocalDateTime validBegin = LocalDateTime.of(workDate, current.period.getValidBeginTime());
                LocalDateTime validEnd = LocalDateTime.of(workDate, current.period.getValidEndTime());
                if (!validEnd.isAfter(validBegin))
                {
                    validEnd = validEnd.plusDays(1);
                }
                current.validBeginTime = validBegin;
                current.validEndTime = validEnd;
            }
            else
            {
                current.validBeginTime = buildDefaultValidBegin(previous, current);
                current.validEndTime = buildDefaultValidEnd(current, next);
            }
        }
        return windows;
    }

    private boolean hasCustomValidWindow(HrShiftPeriod period)
    {
        if (period.getValidBeginTime() == null || period.getValidEndTime() == null)
        {
            return false;
        }
        return !(period.getValidBeginTime().equals(period.getStartTime())
            && period.getValidEndTime().equals(period.getEndTime()));
    }

    private LocalDateTime buildDefaultValidBegin(SegmentWindow previous, SegmentWindow current)
    {
        if (previous == null)
        {
            return current.planInTime.minusMinutes(120);
        }
        return midpoint(previous.planOutTime, current.planInTime);
    }

    private LocalDateTime buildDefaultValidEnd(SegmentWindow current, SegmentWindow next)
    {
        if (next == null)
        {
            return current.planOutTime.plusMinutes(180);
        }
        return midpoint(current.planOutTime, next.planInTime);
    }

    private LocalDateTime midpoint(LocalDateTime left, LocalDateTime right)
    {
        if (left == null)
        {
            return right;
        }
        if (right == null)
        {
            return left;
        }
        if (!right.isAfter(left))
        {
            return right;
        }
        long seconds = ChronoUnit.SECONDS.between(left, right);
        return left.plusSeconds(seconds / 2);
    }

    private int createDemoPunches(HrSchedule schedule, List<HrShiftPeriod> periods, String operator)
    {
        LocalDate workDate = schedule.getWorkDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        List<SegmentWindow> windows = buildSegmentWindows(workDate, periods);
        int mode = (int) ((schedule.getUserId() + workDate.getDayOfMonth()) % 6);
        if (mode == 4)
        {
            return 0;
        }
        int rows = 0;
        for (int i = 0; i < windows.size(); i++)
        {
            SegmentWindow window = windows.get(i);
            if (mode == 3 && i == 0)
            {
                rows += insertDemoPunch(schedule, window.planInTime.plusMinutes(2), operator);
                continue;
            }
            LocalDateTime inTime = window.planInTime.minusMinutes(3);
            LocalDateTime outTime = window.planOutTime.plusMinutes(4);
            if (mode == 1 && i == 0)
            {
                inTime = window.planInTime.plusMinutes(18);
            }
            if (mode == 2 && i == windows.size() - 1)
            {
                outTime = window.planOutTime.minusMinutes(26);
            }
            rows += insertDemoPunch(schedule, inTime, operator);
            if (mode == 5)
            {
                rows += insertDemoPunch(schedule, window.planInTime.plusMinutes(30), operator);
            }
            rows += insertDemoPunch(schedule, outTime, operator);
        }
        return rows;
    }

    private int insertDemoPunch(HrSchedule schedule, LocalDateTime punchTime, String operator)
    {
        HrAttendanceRecord record = new HrAttendanceRecord();
        record.setUserId(schedule.getUserId());
        record.setLoginName(schedule.getLoginName());
        record.setUserName(schedule.getUserName());
        record.setDeptIdSnapshot(schedule.getDeptId());
        record.setDeptNameSnapshot(schedule.getDeptName());
        record.setDeviceUserNo(schedule.getLoginName());
        record.setDeviceName("演示打卡");
        record.setDeviceNo("DEMO");
        record.setDeviceArea("演示环境");
        record.setPunchTime(punchTime);
        record.setSourceType(SOURCE_DEMO);
        record.setPunchType("AUTO");
        record.setSyncBatchNo("DEMO-" + punchTime.toLocalDate());
        record.setSyncTime(LocalDateTime.now());
        record.setRecordStatus("VALID");
        record.setSourceDbKey("DEMO-" + schedule.getUserId() + "-" + punchTime);
        record.setCreateBy(operator);
        return recordMapper.insertHrAttendanceRecord(record);
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

    private int calculateActualMinutes(LocalDateTime actualIn, LocalDateTime actualOut)
    {
        if (actualIn == null || actualOut == null || actualOut.isBefore(actualIn))
        {
            return 0;
        }
        return (int) Math.max(ChronoUnit.MINUTES.between(actualIn, actualOut), 0);
    }

    private int calculatePlanMinutes(HrAttendanceResultSegment segment)
    {
        return calculateActualMinutes(segment.getPlanInTime(), segment.getPlanOutTime());
    }

    private int calculateSegmentMinutes(HrAttendanceResultSegment segment)
    {
        boolean needIn = "1".equals(defaultFlag(segment.getNeedInPunch(), "1"));
        boolean needOut = "1".equals(defaultFlag(segment.getNeedOutPunch(), "1"));
        LocalDateTime actualIn = segment.getActualInTime();
        LocalDateTime actualOut = segment.getActualOutTime();
        if (needIn && needOut)
        {
            return calculateActualMinutes(actualIn, actualOut);
        }
        if (needIn && actualIn != null)
        {
            return calculateActualMinutes(actualIn, segment.getPlanOutTime());
        }
        if (needOut && actualOut != null)
        {
            return calculateActualMinutes(segment.getPlanInTime(), actualOut);
        }
        return 0;
    }

    private int safeInt(Integer value, int defaultValue)
    {
        return value == null ? defaultValue : value;
    }

    private String defaultFlag(String value, String defaultValue)
    {
        return (value == null || value.trim().isEmpty()) ? defaultValue : value;
    }

    private String appendRemark(String origin, String extra)
    {
        if (origin == null || origin.trim().isEmpty())
        {
            return extra;
        }
        return origin + "；" + extra;
    }

    private LocalDateTime minDateTime(LocalDateTime left, LocalDateTime right)
    {
        if (left == null)
        {
            return right;
        }
        if (right == null)
        {
            return left;
        }
        return left.isBefore(right) ? left : right;
    }

    private LocalDateTime maxDateTime(LocalDateTime left, LocalDateTime right)
    {
        if (left == null)
        {
            return right;
        }
        if (right == null)
        {
            return left;
        }
        return left.isAfter(right) ? left : right;
    }

    private PunchSlot findNearestSlot(List<PunchSlot> slots, LocalDateTime punchTime)
    {
        PunchSlot nearest = null;
        long nearestDistance = Long.MAX_VALUE;
        for (PunchSlot slot : slots)
        {
            if (slot.record != null)
            {
                continue;
            }
            long distance = Math.abs(ChronoUnit.MINUTES.between(slot.planTime, punchTime));
            if (distance < nearestDistance)
            {
                nearestDistance = distance;
                nearest = slot;
            }
        }
        return nearest;
    }

    private int countSegmentPunches(HrAttendanceResultSegment segment)
    {
        int count = 0;
        if (segment.getActualInTime() != null)
        {
            count++;
        }
        if (segment.getActualOutTime() != null)
        {
            count++;
        }
        return count;
    }

    private String buildSegmentSummary(HrAttendanceResultSegment segment)
    {
        return segment.getSegmentName()
            + "("
            + translateStatus(segment.getSegmentStatus())
            + " "
            + formatTime(segment.getActualInTime())
            + "/"
            + formatTime(segment.getActualOutTime())
            + ")";
    }

    private String formatTime(LocalDateTime time)
    {
        return time == null ? "-" : time.toLocalTime().toString().substring(0, 5);
    }

    private String translateStatus(String status)
    {
        if (status == null)
        {
            return "";
        }
        switch (status)
        {
            case "NORMAL":
                return "正常";
            case "PENDING_CLOCK":
                return "待打卡";
            case "MISS_CARD":
                return "缺卡";
            case "LATE":
                return "迟到";
            case "EARLY":
                return "早退";
            case "LATE_EARLY":
                return "迟到早退";
            case "ABSENT":
                return "旷工";
            default:
                return status;
        }
    }

    private String translateException(String type)
    {
        if (type == null)
        {
            return null;
        }
        switch (type)
        {
            case "LATE":
                return "迟到";
            case "EARLY":
                return "早退";
            case "MISS_CARD":
                return "缺卡";
            case "ABSENT":
                return "旷工";
            default:
                return null;
        }
    }

    private static class SegmentWindow
    {
        private LocalDate workDate;
        private HrShiftPeriod period;
        private LocalDateTime planInTime;
        private LocalDateTime planOutTime;
        private LocalDateTime validBeginTime;
        private LocalDateTime validEndTime;
    }

    private static class PunchSlot
    {
        private final HrAttendanceResultSegment segment;
        private final String punchKind;
        private final LocalDateTime planTime;
        private HrAttendanceRecord record;

        private PunchSlot(HrAttendanceResultSegment segment, String punchKind, LocalDateTime planTime)
        {
            this.segment = segment;
            this.punchKind = punchKind;
            this.planTime = planTime;
        }
    }
}
