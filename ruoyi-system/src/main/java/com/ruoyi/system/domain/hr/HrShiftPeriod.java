package com.ruoyi.system.domain.hr;

import java.time.LocalTime;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrShiftPeriod extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long periodId;
    private Long shiftId;
    private Integer periodNo;
    private String segmentName;
    private LocalTime startTime;
    private LocalTime endTime;
    private LocalTime validBeginTime;
    private LocalTime validEndTime;
    private String needInPunch;
    private String needOutPunch;
    private String crossDay;
    private String segmentRemark;

    public Long getPeriodId() { return periodId; }
    public void setPeriodId(Long periodId) { this.periodId = periodId; }
    public Long getShiftId() { return shiftId; }
    public void setShiftId(Long shiftId) { this.shiftId = shiftId; }
    public Integer getPeriodNo() { return periodNo; }
    public void setPeriodNo(Integer periodNo) { this.periodNo = periodNo; }
    public String getSegmentName() { return segmentName; }
    public void setSegmentName(String segmentName) { this.segmentName = segmentName; }
    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }
    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }
    public LocalTime getValidBeginTime() { return validBeginTime; }
    public void setValidBeginTime(LocalTime validBeginTime) { this.validBeginTime = validBeginTime; }
    public LocalTime getValidEndTime() { return validEndTime; }
    public void setValidEndTime(LocalTime validEndTime) { this.validEndTime = validEndTime; }
    public String getNeedInPunch() { return needInPunch; }
    public void setNeedInPunch(String needInPunch) { this.needInPunch = needInPunch; }
    public String getNeedOutPunch() { return needOutPunch; }
    public void setNeedOutPunch(String needOutPunch) { this.needOutPunch = needOutPunch; }
    public String getCrossDay() { return crossDay; }
    public void setCrossDay(String crossDay) { this.crossDay = crossDay; }
    public String getSegmentRemark() { return segmentRemark; }
    public void setSegmentRemark(String segmentRemark) { this.segmentRemark = segmentRemark; }
}