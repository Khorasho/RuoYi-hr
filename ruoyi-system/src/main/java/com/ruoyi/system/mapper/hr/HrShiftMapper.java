package com.ruoyi.system.mapper.hr;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;

public interface HrShiftMapper
{
    List<HrShift> selectHrShiftList(HrShift shift);

    HrShift selectHrShiftById(Long shiftId);

    HrShift selectByShiftCode(@Param("shiftCode") String shiftCode);

    HrShift selectRestShift();

    int insertHrShift(HrShift shift);

    int updateHrShift(HrShift shift);

    int deleteHrShiftByIds(Long[] ids);

    int countScheduleRefByShiftIds(Long[] ids);

    int countEmployeeSettingRefByShiftIds(Long[] ids);

    int countEmployeeSettingRefByShiftId(Long shiftId);

    int countByShiftCode(@Param("shiftCode") String shiftCode, @Param("excludeShiftId") Long excludeShiftId);

    List<HrShiftPeriod> selectPeriodsByShiftId(Long shiftId);

    int deletePeriodsByShiftId(Long shiftId);

    int batchInsertPeriods(List<HrShiftPeriod> periods);
}
