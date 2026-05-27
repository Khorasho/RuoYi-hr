package com.ruoyi.system.domain.hr;

import java.time.LocalDate;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceResultSegment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long segmentResultId;
    private Long resultId;
    private Long scheduleId;
    private Long userId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate workDate;
    private Long shiftId;
    private Integer segmentNo;
    private String segmentName;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime planInTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime planOutTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime validBeginTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime validEndTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime actualInTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime actualOutTime;
    private String needInPunch;
    private String needOutPunch;
    private Integer punchCount;
    private String segmentStatus;
    private String lateFlag;
    private String earlyFlag;
    private String missCardFlag;
    private String absentFlag;
    private Integer workMinutes;
    private String remark;

    public Long getSegmentResultId() { return segmentResultId; }
    public void setSegmentResultId(Long segmentResultId) { this.segmentResultId = segmentResultId; }
    public Long getResultId() { return resultId; }
    public void setResultId(Long resultId) { this.resultId = resultId; }
    public Long getScheduleId() { return scheduleId; }
    public void setScheduleId(Long scheduleId) { this.scheduleId = scheduleId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public LocalDate getWorkDate() { return workDate; }
    public void setWorkDate(LocalDate workDate) { this.workDate = workDate; }
    public Long getShiftId() { return shiftId; }
    public void setShiftId(Long shiftId) { this.shiftId = shiftId; }
    public Integer getSegmentNo() { return segmentNo; }
    public void setSegmentNo(Integer segmentNo) { this.segmentNo = segmentNo; }
    public String getSegmentName() { return segmentName; }
    public void setSegmentName(String segmentName) { this.segmentName = segmentName; }
    public LocalDateTime getPlanInTime() { return planInTime; }
    public void setPlanInTime(LocalDateTime planInTime) { this.planInTime = planInTime; }
    public LocalDateTime getPlanOutTime() { return planOutTime; }
    public void setPlanOutTime(LocalDateTime planOutTime) { this.planOutTime = planOutTime; }
    public LocalDateTime getValidBeginTime() { return validBeginTime; }
    public void setValidBeginTime(LocalDateTime validBeginTime) { this.validBeginTime = validBeginTime; }
    public LocalDateTime getValidEndTime() { return validEndTime; }
    public void setValidEndTime(LocalDateTime validEndTime) { this.validEndTime = validEndTime; }
    public LocalDateTime getActualInTime() { return actualInTime; }
    public void setActualInTime(LocalDateTime actualInTime) { this.actualInTime = actualInTime; }
    public LocalDateTime getActualOutTime() { return actualOutTime; }
    public void setActualOutTime(LocalDateTime actualOutTime) { this.actualOutTime = actualOutTime; }
    public String getNeedInPunch() { return needInPunch; }
    public void setNeedInPunch(String needInPunch) { this.needInPunch = needInPunch; }
    public String getNeedOutPunch() { return needOutPunch; }
    public void setNeedOutPunch(String needOutPunch) { this.needOutPunch = needOutPunch; }
    public Integer getPunchCount() { return punchCount; }
    public void setPunchCount(Integer punchCount) { this.punchCount = punchCount; }
    public String getSegmentStatus() { return segmentStatus; }
    public void setSegmentStatus(String segmentStatus) { this.segmentStatus = segmentStatus; }
    public String getLateFlag() { return lateFlag; }
    public void setLateFlag(String lateFlag) { this.lateFlag = lateFlag; }
    public String getEarlyFlag() { return earlyFlag; }
    public void setEarlyFlag(String earlyFlag) { this.earlyFlag = earlyFlag; }
    public String getMissCardFlag() { return missCardFlag; }
    public void setMissCardFlag(String missCardFlag) { this.missCardFlag = missCardFlag; }
    public String getAbsentFlag() { return absentFlag; }
    public void setAbsentFlag(String absentFlag) { this.absentFlag = absentFlag; }
    public Integer getWorkMinutes() { return workMinutes; }
    public void setWorkMinutes(Integer workMinutes) { this.workMinutes = workMinutes; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}