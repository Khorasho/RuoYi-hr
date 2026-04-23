package com.ruoyi.system.mapper.hr;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.hr.HrAttendanceException;
import com.ruoyi.system.domain.hr.HrAttendanceResult;

public interface HrAttendanceResultMapper
{
    int insertHrAttendanceResult(HrAttendanceResult result);
    int deleteByDate(LocalDate workDate);
    int deleteByMonth(String monthStr);
    List<HrAttendanceResult> selectHrAttendanceResultList(HrAttendanceResult result);
    int insertHrAttendanceException(HrAttendanceException exception);
    int deleteExceptionsByDate(LocalDate workDate);
    List<Map<String, Object>> selectMonthDeptSummary(String monthStr, Long deptId, Long userId);
    List<Map<String, Object>> selectMonthUserSummary(String monthStr, Long deptId, Long userId);
}
