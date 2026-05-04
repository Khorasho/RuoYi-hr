package com.ruoyi.system.service.hr.impl;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;
import com.ruoyi.system.mapper.hr.HrShiftMapper;
import com.ruoyi.system.service.hr.IHrShiftService;

@Service
public class HrShiftServiceImpl implements IHrShiftService
{
    @Autowired
    private HrShiftMapper shiftMapper;

    @Override
    public List<HrShift> selectHrShiftList(HrShift shift)
    {
        return shiftMapper.selectHrShiftList(shift);
    }

    @Override
    public HrShift selectHrShiftById(Long shiftId)
    {
        return shiftMapper.selectHrShiftById(shiftId);
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
        return shiftMapper.selectPeriodsByShiftId(shiftId);
    }

    @Override
    @Transactional
    public int insertHrShift(HrShift shift, List<HrShiftPeriod> periods)
    {
        fillDefaultWorkdayMask(shift);
        validatePeriods(periods);
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
        fillDefaultWorkdayMask(shift);
        validatePeriods(periods);
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
        int refCount = shiftMapper.countScheduleRefByShiftIds(shiftIds);
        if (refCount > 0)
        {
            throw new ServiceException("删除失败：存在员工仍绑定该班次，请先在班次员工中移除后再删除");
        }
        return shiftMapper.deleteHrShiftByIds(shiftIds);
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
        if (periods == null || periods.isEmpty())
        {
            shift.setExpectedStartTime(null);
            shift.setExpectedEndTime(null);
            return;
        }
        LocalTime min = null;
        LocalTime max = null;
        for (HrShiftPeriod period : periods)
        {
            if (period.getStartTime() != null && (min == null || period.getStartTime().isBefore(min)))
            {
                min = period.getStartTime();
            }
            if (period.getEndTime() != null && (max == null || period.getEndTime().isAfter(max)))
            {
                max = period.getEndTime();
            }
        }
        shift.setExpectedStartTime(min);
        shift.setExpectedEndTime(max);
    }

    private void validatePeriods(List<HrShiftPeriod> periods)
    {
        if (periods == null || periods.isEmpty())
        {
            throw new ServiceException("请至少配置一个班次时段");
        }
        for (HrShiftPeriod period : periods)
        {
            if (period.getStartTime() == null || period.getEndTime() == null)
            {
                throw new ServiceException("班次时段开始/结束时间不能为空");
            }
            if (!period.getEndTime().isAfter(period.getStartTime()))
            {
                throw new ServiceException("班次时段结束时间必须晚于开始时间");
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
}
