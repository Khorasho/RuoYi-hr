package com.ruoyi.system.mapper.hr;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;

public interface HrShiftMapper
{
    List<HrShift> selectHrShiftList(HrShift shift);
    HrShift selectHrShiftById(Long shiftId);
    int insertHrShift(HrShift shift);
    int updateHrShift(HrShift shift);
    int deleteHrShiftByIds(Long[] ids);
    int countByShiftCode(@Param("shiftCode") String shiftCode, @Param("excludeShiftId") Long excludeShiftId);
    List<HrShiftPeriod> selectPeriodsByShiftId(Long shiftId);
    int deletePeriodsByShiftId(Long shiftId);
    int batchInsertPeriods(List<HrShiftPeriod> periods);
}
