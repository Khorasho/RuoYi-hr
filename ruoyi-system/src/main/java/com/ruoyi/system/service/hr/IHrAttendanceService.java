package com.ruoyi.system.service.hr;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.hr.HrAttendanceResult;

public interface IHrAttendanceService
{
    int recalculateDay(LocalDate workDate, String operator);
    int recalculateMonth(String month, String operator);
    List<HrAttendanceResult> selectAttendanceResultList(HrAttendanceResult query);
    List<Map<String, Object>> selectMonthDeptSummary(String month, Long deptId, Long userId);
    List<Map<String, Object>> selectMonthUserSummary(String month, Long deptId, Long userId);
}
