package com.ruoyi.system.domain.hr;

import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceRule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long ruleId;
    private Integer lateMinutes;
    private Integer earlyMinutes;
    private Integer absentMinutes;
    private String multiPunchStrategy;

    public Long getRuleId() { return ruleId; }
    public void setRuleId(Long ruleId) { this.ruleId = ruleId; }
    public Integer getLateMinutes() { return lateMinutes; }
    public void setLateMinutes(Integer lateMinutes) { this.lateMinutes = lateMinutes; }
    public Integer getEarlyMinutes() { return earlyMinutes; }
    public void setEarlyMinutes(Integer earlyMinutes) { this.earlyMinutes = earlyMinutes; }
    public Integer getAbsentMinutes() { return absentMinutes; }
    public void setAbsentMinutes(Integer absentMinutes) { this.absentMinutes = absentMinutes; }
    public String getMultiPunchStrategy() { return multiPunchStrategy; }
    public void setMultiPunchStrategy(String multiPunchStrategy) { this.multiPunchStrategy = multiPunchStrategy; }
}
