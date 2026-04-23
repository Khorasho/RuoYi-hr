package com.ruoyi.system.domain.hr;

import java.time.LocalTime;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrShiftPeriod extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long periodId;
    private Long shiftId;
    private Integer periodNo;
    private LocalTime startTime;
    private LocalTime endTime;

    public Long getPeriodId() { return periodId; }
    public void setPeriodId(Long periodId) { this.periodId = periodId; }
    public Long getShiftId() { return shiftId; }
    public void setShiftId(Long shiftId) { this.shiftId = shiftId; }
    public Integer getPeriodNo() { return periodNo; }
    public void setPeriodNo(Integer periodNo) { this.periodNo = periodNo; }
    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }
    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }
}
