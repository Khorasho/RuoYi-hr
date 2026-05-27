package com.ruoyi.system.domain.hr;

import java.time.LocalDate;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceResult extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long resultId;
    private Long scheduleId;
    private Long userId;

    @Excel(name = "工号")
    private String loginName;

    @Excel(name = "姓名")
    private String userName;

    private Long deptId;

    @Excel(name = "部门")
    private String deptName;

    @Excel(name = "日期")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate workDate;

    private Long shiftId;

    @Excel(name = "班次")
    private String shiftName;

    @Excel(name = "休息类型")
    private String restType;

    @Excel(name = "考勤状态")
    private String attendanceStatus;

    @Excel(name = "异常类型")
    private String exceptionType;

    @Excel(name = "应上班")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime expectedInTime;

    @Excel(name = "应下班")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime expectedOutTime;

    @Excel(name = "实际上班")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime actualInTime;

    @Excel(name = "实际下班")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime actualOutTime;

    @Excel(name = "打卡次数")
    private Integer punchCount;

    @Excel(name = "迟到", readConverterExp = "1=是,0=否")
    private String lateFlag;

    @Excel(name = "早退", readConverterExp = "1=是,0=否")
    private String earlyFlag;

    @Excel(name = "缺卡", readConverterExp = "1=是,0=否")
    private String missCardFlag;

    @Excel(name = "旷工", readConverterExp = "1=是,0=否")
    private String absentFlag;

    @Excel(name = "应出勤分钟")
    private Integer expectedMinutes;

    @Excel(name = "实出勤分钟")
    private Integer actualMinutes;

    @Excel(name = "班段明细")
    private String segmentSummary;

    @Excel(name = "上1")
    private String segment1InDisplay;

    @Excel(name = "下1")
    private String segment1OutDisplay;

    @Excel(name = "段1结果")
    private String segment1Status;

    @Excel(name = "上2")
    private String segment2InDisplay;

    @Excel(name = "下2")
    private String segment2OutDisplay;

    @Excel(name = "段2结果")
    private String segment2Status;

    @Excel(name = "上3")
    private String segment3InDisplay;

    @Excel(name = "下3")
    private String segment3OutDisplay;

    @Excel(name = "段3结果")
    private String segment3Status;

    @Excel(name = "数据来源")
    private String dataSource;

    @Excel(name = "备注")
    private String remark;

    public Long getResultId() { return resultId; }
    public void setResultId(Long resultId) { this.resultId = resultId; }
    public Long getScheduleId() { return scheduleId; }
    public void setScheduleId(Long scheduleId) { this.scheduleId = scheduleId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getLoginName() { return loginName; }
    public void setLoginName(String loginName) { this.loginName = loginName; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public LocalDate getWorkDate() { return workDate; }
    public void setWorkDate(LocalDate workDate) { this.workDate = workDate; }
    public Long getShiftId() { return shiftId; }
    public void setShiftId(Long shiftId) { this.shiftId = shiftId; }
    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }
    public String getRestType() { return restType; }
    public void setRestType(String restType) { this.restType = restType; }
    public String getAttendanceStatus() { return attendanceStatus; }
    public void setAttendanceStatus(String attendanceStatus) { this.attendanceStatus = attendanceStatus; }
    public String getExceptionType() { return exceptionType; }
    public void setExceptionType(String exceptionType) { this.exceptionType = exceptionType; }
    public LocalDateTime getExpectedInTime() { return expectedInTime; }
    public void setExpectedInTime(LocalDateTime expectedInTime) { this.expectedInTime = expectedInTime; }
    public LocalDateTime getExpectedOutTime() { return expectedOutTime; }
    public void setExpectedOutTime(LocalDateTime expectedOutTime) { this.expectedOutTime = expectedOutTime; }
    public LocalDateTime getActualInTime() { return actualInTime; }
    public void setActualInTime(LocalDateTime actualInTime) { this.actualInTime = actualInTime; }
    public LocalDateTime getActualOutTime() { return actualOutTime; }
    public void setActualOutTime(LocalDateTime actualOutTime) { this.actualOutTime = actualOutTime; }
    public Integer getPunchCount() { return punchCount; }
    public void setPunchCount(Integer punchCount) { this.punchCount = punchCount; }
    public String getLateFlag() { return lateFlag; }
    public void setLateFlag(String lateFlag) { this.lateFlag = lateFlag; }
    public String getEarlyFlag() { return earlyFlag; }
    public void setEarlyFlag(String earlyFlag) { this.earlyFlag = earlyFlag; }
    public String getMissCardFlag() { return missCardFlag; }
    public void setMissCardFlag(String missCardFlag) { this.missCardFlag = missCardFlag; }
    public String getAbsentFlag() { return absentFlag; }
    public void setAbsentFlag(String absentFlag) { this.absentFlag = absentFlag; }
    public Integer getExpectedMinutes() { return expectedMinutes; }
    public void setExpectedMinutes(Integer expectedMinutes) { this.expectedMinutes = expectedMinutes; }
    public Integer getActualMinutes() { return actualMinutes; }
    public void setActualMinutes(Integer actualMinutes) { this.actualMinutes = actualMinutes; }
    public String getSegmentSummary() { return segmentSummary; }
    public void setSegmentSummary(String segmentSummary) { this.segmentSummary = segmentSummary; }
    public String getSegment1InDisplay() { return segment1InDisplay; }
    public void setSegment1InDisplay(String segment1InDisplay) { this.segment1InDisplay = segment1InDisplay; }
    public String getSegment1OutDisplay() { return segment1OutDisplay; }
    public void setSegment1OutDisplay(String segment1OutDisplay) { this.segment1OutDisplay = segment1OutDisplay; }
    public String getSegment1Status() { return segment1Status; }
    public void setSegment1Status(String segment1Status) { this.segment1Status = segment1Status; }
    public String getSegment2InDisplay() { return segment2InDisplay; }
    public void setSegment2InDisplay(String segment2InDisplay) { this.segment2InDisplay = segment2InDisplay; }
    public String getSegment2OutDisplay() { return segment2OutDisplay; }
    public void setSegment2OutDisplay(String segment2OutDisplay) { this.segment2OutDisplay = segment2OutDisplay; }
    public String getSegment2Status() { return segment2Status; }
    public void setSegment2Status(String segment2Status) { this.segment2Status = segment2Status; }
    public String getSegment3InDisplay() { return segment3InDisplay; }
    public void setSegment3InDisplay(String segment3InDisplay) { this.segment3InDisplay = segment3InDisplay; }
    public String getSegment3OutDisplay() { return segment3OutDisplay; }
    public void setSegment3OutDisplay(String segment3OutDisplay) { this.segment3OutDisplay = segment3OutDisplay; }
    public String getSegment3Status() { return segment3Status; }
    public void setSegment3Status(String segment3Status) { this.segment3Status = segment3Status; }
    public String getDataSource() { return dataSource; }
    public void setDataSource(String dataSource) { this.dataSource = dataSource; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
