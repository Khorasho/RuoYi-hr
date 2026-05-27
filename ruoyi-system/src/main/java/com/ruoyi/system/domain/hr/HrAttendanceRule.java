package com.ruoyi.system.domain.hr;

import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceRule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long ruleId;

    /**
     * 迟到阈值，超过上班时间多少分钟后记迟到。
     */
    private Integer lateMinutes;

    /**
     * 早退阈值，早于下班时间多少分钟后记早退。
     */
    private Integer earlyMinutes;

    /**
     * 少于计划出勤多少分钟后记旷工。
     */
    private Integer absentMinutes;

    /**
     * 下班后超过多少分钟，将当天考勤封存并开始判定缺卡/旷工。
     */
    private Integer dayCloseMinutes;

    /**
     * 多次打卡取值策略。
     */
    private String multiPunchStrategy;

    public Long getRuleId()
    {
        return ruleId;
    }

    public void setRuleId(Long ruleId)
    {
        this.ruleId = ruleId;
    }

    public Integer getLateMinutes()
    {
        return lateMinutes;
    }

    public void setLateMinutes(Integer lateMinutes)
    {
        this.lateMinutes = lateMinutes;
    }

    public Integer getEarlyMinutes()
    {
        return earlyMinutes;
    }

    public void setEarlyMinutes(Integer earlyMinutes)
    {
        this.earlyMinutes = earlyMinutes;
    }

    public Integer getAbsentMinutes()
    {
        return absentMinutes;
    }

    public void setAbsentMinutes(Integer absentMinutes)
    {
        this.absentMinutes = absentMinutes;
    }

    public Integer getDayCloseMinutes()
    {
        return dayCloseMinutes;
    }

    public void setDayCloseMinutes(Integer dayCloseMinutes)
    {
        this.dayCloseMinutes = dayCloseMinutes;
    }

    public String getMultiPunchStrategy()
    {
        return multiPunchStrategy;
    }

    public void setMultiPunchStrategy(String multiPunchStrategy)
    {
        this.multiPunchStrategy = multiPunchStrategy;
    }
}
