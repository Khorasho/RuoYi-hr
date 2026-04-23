package com.ruoyi.system.domain.hr;

import java.time.LocalDate;
import java.time.LocalDateTime;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceResult extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long resultId;
    @Excel(name = "用户ID")
    private Long userId;
    @Excel(name = "员工")
    private String userName;
    @Excel(name = "部门")
    private String deptName;
    @Excel(name = "日期")
    private LocalDate workDate;
    @Excel(name = "班次")
    private String shiftName;
    @Excel(name = "应上班")
    private LocalDateTime expectedInTime;
    @Excel(name = "应下班")
    private LocalDateTime expectedOutTime;
    @Excel(name = "实上班")
    private LocalDateTime actualInTime;
    @Excel(name = "实下班")
    private LocalDateTime actualOutTime;
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

    public Long getResultId() { return resultId; }
    public void setResultId(Long resultId) { this.resultId = resultId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public LocalDate getWorkDate() { return workDate; }
    public void setWorkDate(LocalDate workDate) { this.workDate = workDate; }
    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }
    public LocalDateTime getExpectedInTime() { return expectedInTime; }
    public void setExpectedInTime(LocalDateTime expectedInTime) { this.expectedInTime = expectedInTime; }
    public LocalDateTime getExpectedOutTime() { return expectedOutTime; }
    public void setExpectedOutTime(LocalDateTime expectedOutTime) { this.expectedOutTime = expectedOutTime; }
    public LocalDateTime getActualInTime() { return actualInTime; }
    public void setActualInTime(LocalDateTime actualInTime) { this.actualInTime = actualInTime; }
    public LocalDateTime getActualOutTime() { return actualOutTime; }
    public void setActualOutTime(LocalDateTime actualOutTime) { this.actualOutTime = actualOutTime; }
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
}
