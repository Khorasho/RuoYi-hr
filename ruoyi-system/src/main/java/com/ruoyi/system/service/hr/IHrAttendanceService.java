package com.ruoyi.system.service.hr;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.hr.HrAttendanceRecord;
import com.ruoyi.system.domain.hr.HrAttendanceReportQuery;
import com.ruoyi.system.domain.hr.HrDeptAttendanceReport;
import com.ruoyi.system.domain.hr.HrAttendanceResult;
import com.ruoyi.system.domain.hr.HrAttendanceResultSegment;
import com.ruoyi.system.domain.hr.HrUserAttendanceReport;

public interface IHrAttendanceService
{
    int generateDateRange(LocalDate beginDate, LocalDate endDate, String operator);

    int generateMonthly(String month, String operator);

    int syncFutureAttendance(int days, String operator);

    int recalculateDay(LocalDate workDate, String operator);

    int recalculateMonth(String month, String operator);

    int generateDemoPunches(String month, String operator);

    List<HrAttendanceResult> selectAttendanceResultList(HrAttendanceResult query);

    HrAttendanceResult selectAttendanceResultById(Long resultId);

    List<HrAttendanceResultSegment> selectAttendanceResultSegments(Long resultId);

    List<HrAttendanceRecord> selectAttendancePunchRecords(Long userId, LocalDate workDate);

    List<Map<String, Object>> selectMonthDeptSummary(String month, Long deptId, Long userId);

    List<Map<String, Object>> selectMonthUserSummary(String month, Long deptId, Long userId);

    List<Map<String, Object>> selectYearDeptSummary(String year, Long deptId, Long userId);

    List<Map<String, Object>> selectYearUserSummary(String year, Long deptId, Long userId);

    List<HrDeptAttendanceReport> selectMonthDeptReport(HrAttendanceReportQuery query);

    List<HrUserAttendanceReport> selectMonthUserReport(HrAttendanceReportQuery query);

    List<HrDeptAttendanceReport> selectYearDeptReport(HrAttendanceReportQuery query);

    List<HrUserAttendanceReport> selectYearUserReport(HrAttendanceReportQuery query);
}
