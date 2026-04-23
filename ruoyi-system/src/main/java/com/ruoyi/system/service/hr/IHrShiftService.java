package com.ruoyi.system.service.hr;

import java.util.List;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;

public interface IHrShiftService
{
    List<HrShift> selectHrShiftList(HrShift shift);
    HrShift selectHrShiftById(Long shiftId);
    String generateShiftCode(String shiftName, Long excludeShiftId);
    int insertHrShift(HrShift shift, List<HrShiftPeriod> periods);
    int updateHrShift(HrShift shift, List<HrShiftPeriod> periods);
    int deleteHrShiftByIds(String ids);
    List<HrShiftPeriod> selectPeriodsByShiftId(Long shiftId);
}
