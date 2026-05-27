package com.ruoyi.system.service.hr.impl;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrShiftService;

@Service
public class HrShiftServiceImpl implements IHrShiftService
{
    private static final String SCHEDULE_MODE_WEEKLY = "WEEKLY";
    private static final String SCHEDULE_MODE_ROTATION = "ROTATION";
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private HrShiftMapper shiftMapper;

    @Override
    public List<HrShift> selectHrShiftList(HrShift shift)
    {
        List<HrShift> list = shiftMapper.selectHrShiftList(shift);
        if (list == null || list.isEmpty())
        {
            return list;
        }
        for (HrShift item : list)
        {
            normalizeShift(item);
        }
        return list;
    }

    @Override
    public HrShift selectHrShiftById(Long shiftId)
    {
        HrShift shift = shiftMapper.selectHrShiftById(shiftId);
        normalizeShift(shift);
        return shift;
    }

    @Override
    public HrShift selectRestShift()
    {
        return shiftMapper.selectRestShift();
    }

    @Override
    public String generateShiftCode(String shiftName, Long excludeShiftId)
    {
        String codeBase = toCodeBase(shiftName);
        String code = codeBase;
        int seq = 2;
        while (shiftMapper.countByShiftCode(code, excludeShiftId) > 0)
        {
            code = codeBase + "_" + seq;
            seq++;
        }
        return code;
    }

    @Override
    public List<HrShiftPeriod> selectPeriodsByShiftId(Long shiftId)
    {
        List<HrShiftPeriod> periods = shiftMapper.selectPeriodsByShiftId(shiftId);
        normalizePeriodsForDisplay(periods);
        return periods;
    }

    @Override
    @Transactional
    public int insertHrShift(HrShift shift, List<HrShiftPeriod> periods)
    {
        fillDefaultRestFlag(shift);
        fillDefaultWorkdayMask(shift);
        validateShiftState(shift);
        normalizePeriods(periods);
        validatePeriods(shift, periods);
        buildExpectedRange(shift, periods);
        int rows = shiftMapper.insertHrShift(shift);
        if (rows <= 0)
        {
            throw new ServiceException("新增班次失败");
        }
        savePeriods(shift.getShiftId(), shift.getCreateBy(), periods);
        return rows;
    }

    @Override
    @Transactional
    public int updateHrShift(HrShift shift, List<HrShiftPeriod> periods)
    {
        fillDefaultRestFlag(shift);
        fillDefaultWorkdayMask(shift);
        validateShiftState(shift);
        validateDefaultShiftReference(shift);
        normalizePeriods(periods);
        validatePeriods(shift, periods);
        buildExpectedRange(shift, periods);
        int rows = shiftMapper.updateHrShift(shift);
        if (rows <= 0)
        {
            throw new ServiceException("修改班次失败：记录不存在或已删除");
        }
        shiftMapper.deletePeriodsByShiftId(shift.getShiftId());
        savePeriods(shift.getShiftId(), shift.getUpdateBy(), periods);
        return rows;
    }

    @Override
    public int deleteHrShiftByIds(String ids)
    {
        Long[] shiftIds = Convert.toLongArray(ids);
        if (shiftIds == null || shiftIds.length == 0)
        {
            return 0;
        }
        int employeeRefCount = shiftMapper.countEmployeeSettingRefByShiftIds(shiftIds);
        if (employeeRefCount > 0)
        {
            throw new ServiceException("删除失败：存在员工默认班次仍引用该班次，请先调整员工设置后再删除");
        }
        int refCount = shiftMapper.countScheduleRefByShiftIds(shiftIds);
        if (refCount > 0)
        {
            throw new ServiceException("删除失败：存在排班记录仍引用该班次，请先调整排班后再删除");
        }
        return shiftMapper.deleteHrShiftByIds(shiftIds);
    }

    private void validateShiftState(HrShift shift)
    {
        if (shift == null)
        {
            return;
        }
        if (StringUtils.isEmpty(shift.getStatus()))
        {
            shift.setStatus("0");
        }
        if (StringUtils.isEmpty(shift.getSummerExtendEnabled()))
        {
            shift.setSummerExtendEnabled("0");
        }
        if (shift.getSummerExtendMinutes() == null)
        {
            shift.setSummerExtendMinutes(30);
        }
        if (StringUtils.isEmpty(shift.getScheduleMode()))
        {
            shift.setScheduleMode(SCHEDULE_MODE_WEEKLY);
        }
        if (SCHEDULE_MODE_WEEKLY.equals(shift.getScheduleMode()))
        {
            shift.setRotationWorkDays(null);
            shift.setRotationRestDays(null);
        }
    }

    private void validateDefaultShiftReference(HrShift shift)
    {
        if (shift == null || shift.getShiftId() == null)
        {
            return;
        }
        int refCount = shiftMapper.countEmployeeSettingRefByShiftId(shift.getShiftId());
        if (refCount <= 0)
        {
            return;
        }
        if ("1".equals(shift.getIsRestShift()))
        {
            throw new ServiceException("修改失败：该班次已被员工设为默认班次，不能改为休息班次");
        }
        if (!"0".equals(shift.getStatus()))
        {
            throw new ServiceException("修改失败：该班次已被员工设为默认班次，不能停用");
        }
    }

    private void savePeriods(Long shiftId, String operator, List<HrShiftPeriod> periods)
    {
        if (periods == null || periods.isEmpty())
        {
            return;
        }
        List<HrShiftPeriod> saveList = new ArrayList<>();
        for (HrShiftPeriod period : periods)
        {
            if (period.getStartTime() == null || period.getEndTime() == null)
            {
                continue;
            }
            period.setShiftId(shiftId);
            period.setCreateBy(operator);
            saveList.add(period);
        }
        if (!saveList.isEmpty())
        {
            shiftMapper.batchInsertPeriods(saveList);
        }
    }

    private void buildExpectedRange(HrShift shift, List<HrShiftPeriod> periods)
    {
        if ("1".equals(shift.getIsRestShift()))
        {
            shift.setExpectedStartTime(null);
            shift.setExpectedEndTime(null);
            return;
        }
        if (periods == null || periods.isEmpty())
        {
            shift.setExpectedStartTime(null);
            shift.setExpectedEndTime(null);
            return;
        }
        LocalTime min = null;
        HrShiftPeriod maxPeriod = null;
        int maxEndMinutes = -1;
        for (HrShiftPeriod period : periods)
        {
            if (period.getStartTime() != null && (min == null || period.getStartTime().isBefore(min)))
            {
                min = period.getStartTime();
            }
            if (period.getEndTime() != null)
            {
                int currentEndMinutes = period.getEndTime().getHour() * 60 + period.getEndTime().getMinute();
                if ("1".equals(period.getCrossDay()))
                {
                    currentEndMinutes += 24 * 60;
                }
                if (currentEndMinutes > maxEndMinutes)
                {
                    maxEndMinutes = currentEndMinutes;
                    maxPeriod = period;
                }
            }
        }
        shift.setExpectedStartTime(min);
        shift.setExpectedEndTime(maxPeriod != null ? maxPeriod.getEndTime() : null);
    }

    private void normalizePeriods(List<HrShiftPeriod> periods)
    {
        if (periods == null)
        {
            return;
        }
        for (int i = 0; i < periods.size(); i++)
        {
            HrShiftPeriod period = periods.get(i);
            period.setPeriodNo(i + 1);
            period.setSegmentName(normalizeSegmentName(period.getSegmentName(), i + 1));
            if (StringUtils.isEmpty(period.getNeedInPunch()))
            {
                period.setNeedInPunch("1");
            }
            if (StringUtils.isEmpty(period.getNeedOutPunch()))
            {
                period.setNeedOutPunch("1");
            }
            if (StringUtils.isEmpty(period.getCrossDay()))
            {
                period.setCrossDay("0");
            }
            if (period.getValidBeginTime() == null)
            {
                period.setValidBeginTime(period.getStartTime());
            }
            if (period.getValidEndTime() == null)
            {
                period.setValidEndTime(period.getEndTime());
            }
        }
    }

    private void normalizeShift(HrShift shift)
    {
        if (shift == null)
        {
            return;
        }
        shift.setWorkdayMask(normalizeWorkdayMaskForDisplay(shift.getWorkdayMask()));
        List<HrShiftPeriod> periods = shiftMapper.selectPeriodsByShiftId(shift.getShiftId());
        normalizePeriodsForDisplay(periods);
        if (periods == null || periods.isEmpty())
        {
            shift.setPeriodSummary(null);
            shift.setPeriodCount(0);
            shift.setPunchCount(0);
            return;
        }
        shift.setPeriodCount(periods.size());
        int punchCount = 0;
        List<String> summaryList = new ArrayList<>();
        for (HrShiftPeriod period : periods)
        {
            if ("1".equals(period.getNeedInPunch()))
            {
                punchCount++;
            }
            if ("1".equals(period.getNeedOutPunch()))
            {
                punchCount++;
            }
            summaryList.add(period.getSegmentName() + ": " + formatTime(period.getStartTime()) + "-" + formatTime(period.getEndTime())
                + ("1".equals(period.getCrossDay()) ? " (+1)" : ""));
        }
        shift.setPunchCount(punchCount);
        shift.setPeriodSummary(String.join("; ", summaryList));
    }

    private void normalizePeriodsForDisplay(List<HrShiftPeriod> periods)
    {
        if (periods == null)
        {
            return;
        }
        for (HrShiftPeriod period : periods)
        {
            period.setSegmentName(normalizeSegmentName(period.getSegmentName(), period.getPeriodNo()));
            if (StringUtils.isEmpty(period.getNeedInPunch()))
            {
                period.setNeedInPunch("1");
            }
            if (StringUtils.isEmpty(period.getNeedOutPunch()))
            {
                period.setNeedOutPunch("1");
            }
            if (StringUtils.isEmpty(period.getCrossDay()))
            {
                period.setCrossDay("0");
            }
        }
    }

    private String normalizeSegmentName(String segmentName, Integer periodNo)
    {
        String fallback = "第" + (periodNo == null ? 1 : periodNo) + "段";
        String value = segmentName == null ? "" : segmentName.trim();
        if (StringUtils.isEmpty(value))
        {
            return fallback;
        }
        if (looksGarbledSegmentName(value))
        {
            return fallback;
        }
        return value;
    }

    private boolean looksGarbledSegmentName(String value)
    {
        if (StringUtils.isEmpty(value))
        {
            return false;
        }
        if (value.contains("???"))
        {
            return true;
        }
        return value.contains("ç¬¬") || value.contains("æ®µ") || value.contains("Ã") || value.contains("Â");
    }

    private String normalizeWorkdayMaskForDisplay(String mask)
    {
        if (mask == null)
        {
            return "1111100";
        }
        String cleaned = mask.replaceAll("[^01]", "");
        return cleaned.length() == 7 ? cleaned : "1111100";
    }

    private String formatTime(LocalTime time)
    {
        return time == null ? "-" : time.format(TIME_FORMATTER);
    }

    private void validatePeriods(HrShift shift, List<HrShiftPeriod> periods)
    {
        if ("1".equals(shift.getIsRestShift()))
        {
            return;
        }
        if (SCHEDULE_MODE_ROTATION.equals(shift.getScheduleMode()))
        {
            if (shift.getRotationWorkDays() == null || shift.getRotationWorkDays() <= 0)
            {
                throw new ServiceException("轮班模式下，上班天数必须大于 0");
            }
            if (shift.getRotationRestDays() == null || shift.getRotationRestDays() <= 0)
            {
                throw new ServiceException("轮班模式下，休息天数必须大于 0");
            }
        }
        if (periods == null || periods.isEmpty())
        {
            throw new ServiceException("请至少配置一个班段");
        }
        for (HrShiftPeriod period : periods)
        {
            if (period.getStartTime() == null || period.getEndTime() == null)
            {
                throw new ServiceException("班段的上班时间和下班时间不能为空");
            }
            if (period.getValidBeginTime() == null || period.getValidEndTime() == null)
            {
                throw new ServiceException("请为每个班段配置有效打卡开始和结束时间");
            }
            if (!"1".equals(period.getNeedInPunch()) && !"1".equals(period.getNeedOutPunch()))
            {
                throw new ServiceException(period.getSegmentName() + " 至少要保留一个打卡节点");
            }
            if (period.getStartTime().equals(period.getEndTime()))
            {
                throw new ServiceException(period.getSegmentName() + " 的上下班时间不能相同");
            }
            if (!"1".equals(period.getCrossDay()) && !period.getEndTime().isAfter(period.getStartTime()))
            {
                throw new ServiceException(period.getSegmentName() + " 的下班时间必须晚于上班时间；若跨天请勾选跨天");
            }
        }
    }

    private String toCodeBase(String shiftName)
    {
        if (shiftName == null)
        {
            return "SHIFT";
        }
        String upper = shiftName.trim().toUpperCase(Locale.ROOT);
        String normalized = upper
            .replaceAll("[^A-Z0-9\\u4E00-\\u9FA5]+", "_")
            .replaceAll("_+", "_")
            .replaceAll("^_|_$", "");
        String ascii = normalized.replaceAll("[\\u4E00-\\u9FA5]", "");
        if (ascii.isEmpty())
        {
            return "SHIFT";
        }
        if (!ascii.startsWith("SHIFT"))
        {
            ascii = "SHIFT_" + ascii;
        }
        return ascii;
    }

    private void fillDefaultWorkdayMask(HrShift shift)
    {
        if ("1".equals(shift.getIsRestShift()))
        {
            shift.setWorkdayMask("0000000");
            shift.setScheduleMode(SCHEDULE_MODE_WEEKLY);
            shift.setRotationWorkDays(null);
            shift.setRotationRestDays(null);
            return;
        }
        if (SCHEDULE_MODE_ROTATION.equals(shift.getScheduleMode()))
        {
            shift.setWorkdayMask("1111111");
            return;
        }
        String mask = shift.getWorkdayMask();
        if (mask == null)
        {
            shift.setWorkdayMask("1111100");
            return;
        }
        String cleaned = mask.replaceAll("[^01]", "");
        if (cleaned.length() != 7)
        {
            shift.setWorkdayMask("1111100");
            return;
        }
        shift.setWorkdayMask(cleaned);
    }

    private void fillDefaultRestFlag(HrShift shift)
    {
        if (StringUtils.isEmpty(shift.getIsRestShift()))
        {
            shift.setIsRestShift("0");
        }
    }
}
