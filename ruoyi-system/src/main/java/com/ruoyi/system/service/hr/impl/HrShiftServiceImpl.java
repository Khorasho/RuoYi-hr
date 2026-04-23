package com.ruoyi.system.service.hr.impl;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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
        buildExpectedRange(shift, periods);
        int rows = shiftMapper.insertHrShift(shift);
        savePeriods(shift.getShiftId(), shift.getCreateBy(), periods);
        return rows;
    }

    @Override
    @Transactional
    public int updateHrShift(HrShift shift, List<HrShiftPeriod> periods)
    {
        buildExpectedRange(shift, periods);
        int rows = shiftMapper.updateHrShift(shift);
        shiftMapper.deletePeriodsByShiftId(shift.getShiftId());
        savePeriods(shift.getShiftId(), shift.getUpdateBy(), periods);
        return rows;
    }

    @Override
    public int deleteHrShiftByIds(String ids)
    {
        return shiftMapper.deleteHrShiftByIds(Convert.toLongArray(ids));
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
}
