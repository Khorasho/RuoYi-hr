package com.ruoyi.system.service.hr.impl;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.hr.HrEmployeeSetting;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.mapper.hr.HrEmployeeSettingMapper;
import com.ruoyi.system.mapper.hr.HrScheduleMapper;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrAttendanceService;
import com.ruoyi.system.service.hr.IHrScheduleService;

@Service
public class HrScheduleServiceImpl implements IHrScheduleService
{
    private static final String SCHEDULE_MODE_ROTATION = "ROTATION";

    private static final String SOURCE_MANUAL_ADD = "MANUAL_ADD";
    private static final String SOURCE_MANUAL_EDIT = "MANUAL_EDIT";
    private static final String SOURCE_BATCH_GEN = "BATCH_GEN";
    private static final String SOURCE_AUTO_GEN = "AUTO_GEN";

    private static final String MODE_INSERT_ONLY = "INSERT_ONLY";
    private static final String MODE_OVERWRITE_SYSTEM = "OVERWRITE_SYSTEM";
    private static final String MODE_OVERWRITE_ALL = "OVERWRITE_ALL";

    @Autowired
    private HrScheduleMapper scheduleMapper;

    @Autowired
    private HrShiftMapper shiftMapper;

    @Autowired
    private HrEmployeeSettingMapper employeeSettingMapper;

    @Autowired
    private IHrAttendanceService attendanceService;

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
        prepareManualSchedule(schedule, SOURCE_MANUAL_ADD);
        LocalDate syncDate = null;
        if (schedule.getUserId() != null && schedule.getWorkDate() != null)
        {
            LocalDate workDate = toLocalDate(schedule.getWorkDate());
            syncDate = workDate;
            if (overwrite)
            {
                scheduleMapper.deleteByUserAndDate(schedule.getUserId(), workDate);
            }
            else if (scheduleMapper.countByUserAndDate(schedule.getUserId(), workDate) > 0)
            {
                throw new ServiceException("保存失败：该员工在 " + workDate + " 已存在排班，请勿重复保存");
            }
        }
        int rows = scheduleMapper.insertHrSchedule(schedule);
        if (syncDate != null)
        {
            syncAttendanceForDate(syncDate, firstNonBlank(schedule.getCreateBy(), schedule.getUpdateBy(), "system"));
        }
        return rows;
    }

    @Override
    @Transactional
    public int updateHrSchedule(HrSchedule schedule, boolean overwrite)
    {
        HrSchedule before = schedule.getScheduleId() == null ? null : scheduleMapper.selectHrScheduleById(schedule.getScheduleId());
        prepareManualSchedule(schedule, SOURCE_MANUAL_EDIT);
        LocalDate newDate = null;
        if (schedule.getUserId() != null && schedule.getWorkDate() != null)
        {
            LocalDate workDate = toLocalDate(schedule.getWorkDate());
            newDate = workDate;
            int duplicate = scheduleMapper.countByUserAndDateExcludeId(schedule.getScheduleId(), schedule.getUserId(), workDate);
            if (duplicate > 0)
            {
                if (overwrite)
                {
                    scheduleMapper.deleteByUserAndDate(schedule.getUserId(), workDate);
                }
                else
                {
                    throw new ServiceException("保存失败：该员工在 " + workDate + " 已存在其他排班记录");
                }
            }
        }
        int rows = scheduleMapper.updateHrSchedule(schedule);
        Set<LocalDate> dates = new HashSet<>();
        if (before != null && before.getWorkDate() != null)
        {
            dates.add(toLocalDate(before.getWorkDate()));
        }
        if (newDate != null)
        {
            dates.add(newDate);
        }
        syncAttendanceForDates(dates, firstNonBlank(schedule.getUpdateBy(), schedule.getCreateBy(), "system"));
        return rows;
    }

    @Override
    public int deleteHrScheduleByIds(String ids, String operator)
    {
        Long[] scheduleIds = Convert.toLongArray(ids);
        Set<LocalDate> dates = new HashSet<>();
        for (Long scheduleId : scheduleIds)
        {
            HrSchedule schedule = scheduleMapper.selectHrScheduleById(scheduleId);
            if (schedule != null && schedule.getWorkDate() != null)
            {
                dates.add(toLocalDate(schedule.getWorkDate()));
            }
        }
        int rows = scheduleMapper.deleteHrScheduleByIds(scheduleIds);
        syncAttendanceForDates(dates, firstNonBlank(operator, "system"));
        return rows;
    }

    @Override
    @Transactional
    public int generateMonthlySchedule(String month, Long deptId, Long userId, boolean overwrite, String operator)
    {
        List<Long> userIds = userId == null ? null : Collections.singletonList(userId);
        YearMonth yearMonth = YearMonth.parse(month);
        int rows = generateSchedules(month, deptId, userIds, overwrite ? MODE_OVERWRITE_SYSTEM : MODE_INSERT_ONLY, operator, SOURCE_BATCH_GEN);
        syncAttendanceForRange(yearMonth.atDay(1), yearMonth.atEndOfMonth(), operator);
        return rows;
    }

    @Override
    @Transactional
    public int generateMonthlyScheduleBatch(String month, List<Long> userIds, boolean overwrite, String operator)
    {
        YearMonth yearMonth = YearMonth.parse(month);
        int rows = generateSchedules(month, null, userIds, overwrite ? MODE_OVERWRITE_SYSTEM : MODE_INSERT_ONLY, operator, SOURCE_BATCH_GEN);
        syncAttendanceForRange(yearMonth.atDay(1), yearMonth.atEndOfMonth(), operator);
        return rows;
    }

    @Override
    @Transactional
    public int updateScheduleRange(LocalDate beginDate, LocalDate endDate, Long deptId, Long userId, List<Long> userIds, String mode, String operator)
    {
        validateDateRange(beginDate, endDate);
        Set<Long> targetUserIds = new HashSet<>();
        if (userId != null)
        {
            targetUserIds.add(userId);
        }
        if (userIds != null)
        {
            targetUserIds.addAll(userIds);
        }
        int rows = generateSchedules(beginDate, endDate, deptId, targetUserIds.isEmpty() ? null : new ArrayList<>(targetUserIds), normalizeMode(mode), operator, SOURCE_BATCH_GEN);
        syncAttendanceForRange(beginDate, endDate, operator);
        return rows;
    }

    @Override
    @Transactional
    public int copyScheduleRange(LocalDate sourceBeginDate, LocalDate sourceEndDate, LocalDate targetBeginDate, LocalDate targetEndDate, Long deptId, List<Long> userIds, String mode, String operator)
    {
        validateDateRange(sourceBeginDate, sourceEndDate);
        validateDateRange(targetBeginDate, targetEndDate);
        long sourceDays = java.time.temporal.ChronoUnit.DAYS.between(sourceBeginDate, sourceEndDate);
        long targetDays = java.time.temporal.ChronoUnit.DAYS.between(targetBeginDate, targetEndDate);
        if (sourceDays != targetDays)
        {
            throw new ServiceException("源日期范围和目标日期范围天数必须一致");
        }

        List<HrEmployeeSetting> settings = loadEmployeeSettings(deptId, userIds);
        if (settings.isEmpty())
        {
            throw new ServiceException("未找到可复制排班的员工，请先检查员工设置");
        }

        String copyMode = normalizeMode(mode);
        Map<Long, List<HrSchedule>> sourceMap = new HashMap<>();
        for (HrEmployeeSetting setting : settings)
        {
            List<HrSchedule> sourceSchedules = scheduleMapper.selectByUserAndRange(setting.getUserId(), sourceBeginDate, sourceEndDate);
            if (sourceSchedules != null && !sourceSchedules.isEmpty())
            {
                sourceMap.put(setting.getUserId(), sourceSchedules);
            }
        }
        if (sourceMap.isEmpty())
        {
            throw new ServiceException("源时间范围内未找到可复制的排班记录");
        }

        int rows = 0;
        for (HrEmployeeSetting setting : settings)
        {
            List<HrSchedule> sourceSchedules = sourceMap.get(setting.getUserId());
            if (sourceSchedules == null || sourceSchedules.isEmpty())
            {
                continue;
            }
            Map<LocalDate, HrSchedule> targetExistingMap = scheduleMapper.selectByUserAndRange(setting.getUserId(), targetBeginDate, targetEndDate)
                .stream()
                .collect(Collectors.toMap(item -> toLocalDate(item.getWorkDate()), item -> item, (left, right) -> left));

            for (HrSchedule sourceSchedule : sourceSchedules)
            {
                LocalDate sourceDate = toLocalDate(sourceSchedule.getWorkDate());
                long offsetDays = java.time.temporal.ChronoUnit.DAYS.between(sourceBeginDate, sourceDate);
                LocalDate targetDate = targetBeginDate.plusDays(offsetDays);
                HrSchedule targetExisting = targetExistingMap.get(targetDate);
                if (targetExisting == null)
                {
                    HrSchedule newSchedule = new HrSchedule();
                    newSchedule.setUserId(sourceSchedule.getUserId());
                    newSchedule.setDeptId(setting.getDeptId());
                    newSchedule.setWorkDate(toDate(targetDate));
                    newSchedule.setScheduleMonth(targetDate.getYear() + "-" + String.format("%02d", targetDate.getMonthValue()));
                    newSchedule.setShiftId(sourceSchedule.getShiftId());
                    newSchedule.setRestType(sourceSchedule.getRestType());
                    newSchedule.setGenerateSource(SOURCE_BATCH_GEN);
                    newSchedule.setManualModified("1");
                    newSchedule.setScheduleRemark("复制排班(" + sourceBeginDate + "→" + targetBeginDate + ")");
                    newSchedule.setCreateBy(operator);
                    rows += scheduleMapper.insertHrSchedule(newSchedule);
                    continue;
                }
                if (!shouldOverwrite(targetExisting, copyMode, false))
                {
                    continue;
                }
                targetExisting.setDeptId(setting.getDeptId());
                targetExisting.setWorkDate(toDate(targetDate));
                targetExisting.setScheduleMonth(targetDate.getYear() + "-" + String.format("%02d", targetDate.getMonthValue()));
                targetExisting.setShiftId(sourceSchedule.getShiftId());
                targetExisting.setRestType(sourceSchedule.getRestType());
                targetExisting.setGenerateSource(SOURCE_BATCH_GEN);
                targetExisting.setManualModified("1");
                targetExisting.setScheduleRemark("复制排班(" + sourceBeginDate + "→" + targetBeginDate + ")");
                targetExisting.setUpdateBy(operator);
                rows += scheduleMapper.updateHrSchedule(targetExisting);
            }
        }
        syncAttendanceForRange(targetBeginDate, targetEndDate, operator);
        return rows;
    }

    @Override
    @Transactional
    public int syncFutureSchedule(int days, String operator)
    {
        int futureDays = days <= 0 ? 7 : days;
        LocalDate begin = LocalDate.now();
        LocalDate end = begin.plusDays(futureDays - 1L);
        cleanupInvalidSchedules(begin, end);
        int rows = generateSchedules(begin, end, null, null, MODE_OVERWRITE_SYSTEM, operator, SOURCE_AUTO_GEN);
        syncAttendanceForRange(begin, end, operator);
        return rows;
    }

    @Override
    @Transactional
    public int syncEmployeeFutureWindow(Long userId, int days, String operator)
    {
        if (userId == null)
        {
            return 0;
        }
        int futureDays = days <= 0 ? 7 : days;
        LocalDate begin = LocalDate.now();
        LocalDate end = begin.plusDays(futureDays - 1L);
        HrEmployeeSetting setting = employeeSettingMapper.selectHrEmployeeSettingByUserId(userId);
        if (setting == null)
        {
            deleteSchedulesForUserRange(userId, begin, end);
            syncAttendanceForRange(begin, end, operator);
            return 0;
        }

        LocalDate activeBegin = setting.getEntryDate() == null ? null : toLocalDate(setting.getEntryDate());
        LocalDate activeEnd = setting.getLeaveDate() == null ? null : toLocalDate(setting.getLeaveDate());
        boolean available = "1".equals(setting.getAttendanceEnabled())
            && "0".equals(setting.getUserStatus())
            && setting.getEntryDate() != null
            && setting.getDefaultShiftId() != null;

        if (!available)
        {
            deleteSchedulesForUserRange(userId, begin, end);
            syncAttendanceForRange(begin, end, operator);
            return 0;
        }

        if (activeBegin != null && activeBegin.isAfter(begin))
        {
            deleteSchedulesForUserRange(userId, begin, activeBegin.minusDays(1));
        }
        if (activeEnd != null && activeEnd.isBefore(end))
        {
            deleteSchedulesForUserRange(userId, activeEnd.plusDays(1), end);
        }

        LocalDate generateBegin = activeBegin == null || activeBegin.isBefore(begin) ? begin : activeBegin;
        LocalDate generateEnd = activeEnd == null || activeEnd.isAfter(end) ? end : activeEnd;
        int rows = 0;
        if (!generateBegin.isAfter(generateEnd))
        {
            rows = generateSchedules(generateBegin, generateEnd, null, Collections.singletonList(userId), MODE_OVERWRITE_SYSTEM, operator, SOURCE_BATCH_GEN);
        }
        syncAttendanceForRange(begin, end, operator);
        return rows;
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

    private int generateSchedules(String month, Long deptId, List<Long> userIds, String mode, String operator, String source)
    {
        YearMonth yearMonth = YearMonth.parse(month);
        return generateSchedules(yearMonth.atDay(1), yearMonth.atEndOfMonth(), deptId, userIds, mode, operator, source);
    }

    private int generateSchedules(LocalDate beginDate, LocalDate endDate, Long deptId, List<Long> userIds, String mode, String operator, String source)
    {
        validateDateRange(beginDate, endDate);
        List<HrEmployeeSetting> settings = loadEmployeeSettings(deptId, userIds);
        if (settings.isEmpty())
        {
            return 0;
        }

        HrShift restShift = shiftMapper.selectRestShift();
        if (restShift == null || restShift.getShiftId() == null)
        {
            throw new ServiceException("未找到休息班次，请先初始化 SHIFT_REST");
        }

        Map<Long, HrShift> shiftCache = new HashMap<>();
        shiftCache.put(restShift.getShiftId(), restShift);
        int rows = 0;
        for (HrEmployeeSetting setting : settings)
        {
            HrShift defaultShift = shiftCache.computeIfAbsent(setting.getDefaultShiftId(), shiftMapper::selectHrShiftById);
            if (defaultShift == null || !"0".equals(defaultShift.getStatus()))
            {
                continue;
            }
            if ("1".equals(defaultShift.getIsRestShift()))
            {
                continue;
            }

            LocalDate activeBegin = max(beginDate, toLocalDate(setting.getEntryDate()));
            LocalDate activeEnd = min(endDate, setting.getLeaveDate() == null ? endDate : toLocalDate(setting.getLeaveDate()));
            if (activeBegin.isAfter(activeEnd))
            {
                continue;
            }

            Map<LocalDate, HrSchedule> existingMap = scheduleMapper.selectByUserAndRange(setting.getUserId(), activeBegin, activeEnd)
                .stream()
                .collect(Collectors.toMap(item -> toLocalDate(item.getWorkDate()), item -> item, (left, right) -> left));

            for (LocalDate workDate = activeBegin; !workDate.isAfter(activeEnd); workDate = workDate.plusDays(1))
            {
                boolean workday = isScheduledWorkday(defaultShift, setting, workDate);
                HrShift targetShift = workday ? defaultShift : restShift;
                String restType = workday ? "" : "REST";
                HrSchedule existing = existingMap.get(workDate);
                if (existing == null)
                {
                    HrSchedule schedule = buildGeneratedSchedule(setting, targetShift, workDate, restType, operator, source);
                    rows += scheduleMapper.insertHrSchedule(schedule);
                    continue;
                }
                if (existing.getDeptId() == null || !existing.getDeptId().equals(setting.getDeptId()))
                {
                    existing.setDeptId(setting.getDeptId());
                    existing.setUpdateBy(operator);
                    rows += scheduleMapper.updateHrSchedule(existing);
                }
                if (!shouldOverwrite(existing, mode, SOURCE_AUTO_GEN.equals(source)))
                {
                    continue;
                }

                existing.setDeptId(setting.getDeptId());
                existing.setWorkDate(toDate(workDate));
                existing.setScheduleMonth(workDate.getYear() + "-" + String.format("%02d", workDate.getMonthValue()));
                existing.setShiftId(targetShift.getShiftId());
                existing.setRestType(restType);
                existing.setGenerateSource(source);
                existing.setManualModified("0");
                existing.setScheduleRemark(buildRemark(source, workDate));
                existing.setUpdateBy(operator);
                rows += scheduleMapper.updateHrSchedule(existing);
            }
        }
        return rows;
    }

    private List<HrEmployeeSetting> loadEmployeeSettings(Long deptId, List<Long> userIds)
    {
        HrEmployeeSetting query = new HrEmployeeSetting();
        query.setDeptId(deptId);
        query.setAttendanceEnabled("1");
        List<HrEmployeeSetting> list = employeeSettingMapper.selectHrEmployeeSettingList(query);
        if (userIds != null && !userIds.isEmpty())
        {
            Set<Long> idSet = new HashSet<>(userIds);
            list = list.stream().filter(item -> idSet.contains(item.getUserId())).collect(Collectors.toList());
        }
        return list.stream()
            .filter(item -> "0".equals(item.getUserStatus()))
            .filter(item -> item.getEntryDate() != null)
            .filter(item -> item.getDefaultShiftId() != null)
            .collect(Collectors.toList());
    }

    private HrSchedule buildGeneratedSchedule(HrEmployeeSetting setting, HrShift shift, LocalDate workDate, String restType, String operator, String source)
    {
        HrSchedule schedule = new HrSchedule();
        schedule.setUserId(setting.getUserId());
        schedule.setDeptId(setting.getDeptId());
        schedule.setWorkDate(toDate(workDate));
        schedule.setScheduleMonth(workDate.getYear() + "-" + String.format("%02d", workDate.getMonthValue()));
        schedule.setShiftId(shift.getShiftId());
        schedule.setRestType(restType);
        schedule.setGenerateSource(source);
        schedule.setManualModified("0");
        schedule.setScheduleRemark(buildRemark(source, workDate));
        schedule.setCreateBy(operator);
        return schedule;
    }

    private void prepareManualSchedule(HrSchedule schedule, String source)
    {
        if (schedule.getWorkDate() != null)
        {
            LocalDate localDate = toLocalDate(schedule.getWorkDate());
            schedule.setScheduleMonth(localDate.getYear() + "-" + String.format("%02d", localDate.getMonthValue()));
        }
        schedule.setGenerateSource(source);
        schedule.setManualModified("1");
        if (schedule.getShiftId() == null)
        {
            throw new ServiceException("请选择班次");
        }
        HrShift shift = shiftMapper.selectHrShiftById(schedule.getShiftId());
        if (shift == null)
        {
            throw new ServiceException("班次不存在或已删除");
        }
        if ("1".equals(shift.getIsRestShift()))
        {
            if (schedule.getRestType() == null || schedule.getRestType().isEmpty())
            {
                schedule.setRestType("REST");
            }
        }
        else if (schedule.getRestType() == null)
        {
            schedule.setRestType("");
        }
    }

    private boolean shouldOverwrite(HrSchedule existing, String mode, boolean autoMode)
    {
        if (MODE_INSERT_ONLY.equals(mode))
        {
            return false;
        }
        if ("1".equals(existing.getManualModified()) && autoMode)
        {
            return false;
        }
        if (MODE_OVERWRITE_SYSTEM.equals(mode))
        {
            return !"1".equals(existing.getManualModified());
        }
        return MODE_OVERWRITE_ALL.equals(mode);
    }

    private String normalizeMode(String mode)
    {
        if (MODE_OVERWRITE_ALL.equals(mode))
        {
            return MODE_OVERWRITE_ALL;
        }
        if (MODE_OVERWRITE_SYSTEM.equals(mode))
        {
            return MODE_OVERWRITE_SYSTEM;
        }
        return MODE_INSERT_ONLY;
    }

    private String normalizeWorkdayMask(String mask)
    {
        if (mask == null)
        {
            return "1111100";
        }
        String cleaned = mask.replaceAll("[^01]", "");
        return cleaned.length() == 7 ? cleaned : "1111100";
    }

    private boolean isWorkday(String mask, LocalDate date)
    {
        int index = date.getDayOfWeek().getValue() - 1;
        return mask.charAt(index) == '1';
    }

    private boolean isScheduledWorkday(HrShift shift, HrEmployeeSetting setting, LocalDate workDate)
    {
        if (shift == null)
        {
            return false;
        }
        if (SCHEDULE_MODE_ROTATION.equals(shift.getScheduleMode())
            && shift.getRotationWorkDays() != null
            && shift.getRotationWorkDays() > 0
            && shift.getRotationRestDays() != null
            && shift.getRotationRestDays() > 0)
        {
            return isRotationWorkday(shift, setting, workDate);
        }
        return isWorkday(normalizeWorkdayMask(shift.getWorkdayMask()), workDate);
    }

    private boolean isRotationWorkday(HrShift shift, HrEmployeeSetting setting, LocalDate workDate)
    {
        if (shift == null || setting == null || workDate == null)
        {
            return false;
        }
        LocalDate entryDate = toLocalDate(setting.getEntryDate());
        LocalDate anchorDate = setting.getRotationAnchorDate() == null ? entryDate : toLocalDate(setting.getRotationAnchorDate());
        if (anchorDate == null)
        {
            anchorDate = entryDate;
        }
        int cycleDays = shift.getRotationWorkDays() + shift.getRotationRestDays();
        if (cycleDays <= 0)
        {
            return false;
        }
        long offset = ChronoUnit.DAYS.between(anchorDate, workDate);
        long cycleIndex = Math.floorMod(offset, cycleDays);
        return cycleIndex < shift.getRotationWorkDays();
    }

    private String buildRemark(String source, LocalDate workDate)
    {
        if (SOURCE_AUTO_GEN.equals(source))
        {
            return "定时任务生成(" + workDate + ")";
        }
        return "月排班生成(" + workDate.getYear() + "-" + String.format("%02d", workDate.getMonthValue()) + ")";
    }

    private LocalDate toLocalDate(Date date)
    {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    private Date toDate(LocalDate date)
    {
        return Date.from(date.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    private void validateDateRange(LocalDate beginDate, LocalDate endDate)
    {
        if (beginDate == null || endDate == null)
        {
            throw new ServiceException("请选择日期范围");
        }
        if (beginDate.isAfter(endDate))
        {
            throw new ServiceException("开始日期不能晚于结束日期");
        }
    }

    private LocalDate max(LocalDate a, LocalDate b)
    {
        return a.isAfter(b) ? a : b;
    }

    private LocalDate min(LocalDate a, LocalDate b)
    {
        return a.isBefore(b) ? a : b;
    }

    private void deleteSchedulesForUserRange(Long userId, LocalDate beginDate, LocalDate endDate)
    {
        if (userId == null || beginDate == null || endDate == null || beginDate.isAfter(endDate))
        {
            return;
        }
        List<HrSchedule> schedules = scheduleMapper.selectByUserAndRange(userId, beginDate, endDate);
        if (schedules == null || schedules.isEmpty())
        {
            return;
        }
        Long[] ids = schedules.stream().map(HrSchedule::getScheduleId).filter(id -> id != null).toArray(Long[]::new);
        if (ids.length > 0)
        {
            scheduleMapper.deleteHrScheduleByIds(ids);
        }
    }

    private void cleanupInvalidSchedules(LocalDate beginDate, LocalDate endDate)
    {
        if (beginDate == null || endDate == null || beginDate.isAfter(endDate))
        {
            return;
        }
        List<HrSchedule> schedules = scheduleMapper.selectByDateRange(beginDate, endDate);
        if (schedules == null || schedules.isEmpty())
        {
            return;
        }

        List<HrEmployeeSetting> settings = employeeSettingMapper.selectHrEmployeeSettingList(new HrEmployeeSetting());
        Map<Long, HrEmployeeSetting> settingMap = settings.stream()
            .filter(item -> item.getUserId() != null)
            .collect(Collectors.toMap(HrEmployeeSetting::getUserId, item -> item, (left, right) -> left));
        Map<Long, HrShift> shiftCache = new HashMap<>();
        List<Long> deleteIds = new ArrayList<>();

        for (HrSchedule schedule : schedules)
        {
            if (schedule.getScheduleId() == null || schedule.getUserId() == null || schedule.getWorkDate() == null)
            {
                continue;
            }
            HrEmployeeSetting setting = settingMap.get(schedule.getUserId());
            if (setting == null || !isEmployeeScheduleEligible(setting, toLocalDate(schedule.getWorkDate()), shiftCache))
            {
                deleteIds.add(schedule.getScheduleId());
            }
        }

        if (!deleteIds.isEmpty())
        {
            scheduleMapper.deleteHrScheduleByIds(deleteIds.toArray(new Long[0]));
        }
    }

    private boolean isEmployeeScheduleEligible(HrEmployeeSetting setting, LocalDate workDate, Map<Long, HrShift> shiftCache)
    {
        if (setting == null || workDate == null)
        {
            return false;
        }
        if (!"1".equals(setting.getAttendanceEnabled()))
        {
            return false;
        }
        if (!"0".equals(setting.getUserStatus()))
        {
            return false;
        }
        if (setting.getEntryDate() == null || setting.getDefaultShiftId() == null)
        {
            return false;
        }
        LocalDate entryDate = toLocalDate(setting.getEntryDate());
        if (workDate.isBefore(entryDate))
        {
            return false;
        }
        if (setting.getLeaveDate() != null && workDate.isAfter(toLocalDate(setting.getLeaveDate())))
        {
            return false;
        }
        HrShift shift = shiftCache.computeIfAbsent(setting.getDefaultShiftId(), shiftMapper::selectHrShiftById);
        return shift != null && "0".equals(shift.getStatus()) && !"1".equals(shift.getIsRestShift());
    }

    private void syncAttendanceForDate(LocalDate workDate, String operator)
    {
        if (workDate == null)
        {
            return;
        }
        attendanceService.generateDateRange(workDate, workDate, operator);
    }

    private void syncAttendanceForRange(LocalDate beginDate, LocalDate endDate, String operator)
    {
        if (beginDate == null || endDate == null || beginDate.isAfter(endDate))
        {
            return;
        }
        attendanceService.generateDateRange(beginDate, endDate, operator);
    }

    private void syncAttendanceForDates(Set<LocalDate> dates, String operator)
    {
        if (dates == null || dates.isEmpty())
        {
            return;
        }
        for (LocalDate workDate : dates)
        {
            syncAttendanceForDate(workDate, operator);
        }
    }

    private String firstNonBlank(String... values)
    {
        if (values == null)
        {
            return null;
        }
        for (String value : values)
        {
            if (value != null && !value.trim().isEmpty())
            {
                return value;
            }
        }
        return null;
    }
}
