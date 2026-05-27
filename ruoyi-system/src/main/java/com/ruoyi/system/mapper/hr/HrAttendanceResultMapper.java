package com.ruoyi.system.mapper.hr;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.hr.HrAttendanceException;
import com.ruoyi.system.domain.hr.HrAttendanceReportQuery;
import com.ruoyi.system.domain.hr.HrDeptAttendanceReport;
import com.ruoyi.system.domain.hr.HrAttendanceResult;
import com.ruoyi.system.domain.hr.HrUserAttendanceReport;

public interface HrAttendanceResultMapper
{
    int insertHrAttendanceResult(HrAttendanceResult result);

    int updateHrAttendanceResult(HrAttendanceResult result);

    int deleteByDate(LocalDate workDate);

    int deleteByMonth(String monthStr);

    int deleteByDateRange(@Param("beginDate") LocalDate beginDate, @Param("endDate") LocalDate endDate);

    List<HrAttendanceResult> selectHrAttendanceResultList(HrAttendanceResult result);

    HrAttendanceResult selectByUserAndDate(@Param("userId") Long userId, @Param("workDate") LocalDate workDate);

    HrAttendanceResult selectByResultId(@Param("resultId") Long resultId);

    int insertHrAttendanceException(HrAttendanceException exception);

    int deleteExceptionsByDate(LocalDate workDate);

    int deleteExceptionsByDateRange(@Param("beginDate") LocalDate beginDate, @Param("endDate") LocalDate endDate);

    List<Map<String, Object>> selectMonthDeptSummary(@Param("monthStr") String monthStr, @Param("deptId") Long deptId, @Param("userId") Long userId);

    List<Map<String, Object>> selectMonthUserSummary(@Param("monthStr") String monthStr, @Param("deptId") Long deptId, @Param("userId") Long userId);

    List<Map<String, Object>> selectYearDeptSummary(@Param("yearStr") String yearStr, @Param("deptId") Long deptId, @Param("userId") Long userId);

    List<Map<String, Object>> selectYearUserSummary(@Param("yearStr") String yearStr, @Param("deptId") Long deptId, @Param("userId") Long userId);

    List<HrDeptAttendanceReport> selectMonthDeptReport(HrAttendanceReportQuery query);

    List<HrUserAttendanceReport> selectMonthUserReport(HrAttendanceReportQuery query);

    List<HrDeptAttendanceReport> selectYearDeptReport(HrAttendanceReportQuery query);

    List<HrUserAttendanceReport> selectYearUserReport(HrAttendanceReportQuery query);
}
