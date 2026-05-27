package com.ruoyi.system.domain.hr;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrUserAttendanceReport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long userId;

    @Excel(name = "工号")
    private String loginName;

    @Excel(name = "姓名")
    private String userName;

    private Long deptId;

    @Excel(name = "部门")
    private String deptName;

    @Excel(name = "应出勤天数")
    private Integer needDays;

    @Excel(name = "实出勤天数")
    private Integer workDays;

    @Excel(name = "休息天数")
    private Integer restDays;

    @Excel(name = "迟到次数")
    private Integer lateCount;

    @Excel(name = "早退次数")
    private Integer earlyCount;

    @Excel(name = "缺卡次数")
    private Integer missCardCount;

    @Excel(name = "旷工次数")
    private Integer absentCount;

    @Excel(name = "实出勤分钟")
    private Integer actualMinutes;

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getLoginName()
    {
        return loginName;
    }

    public void setLoginName(String loginName)
    {
        this.loginName = loginName;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public Integer getNeedDays()
    {
        return needDays;
    }

    public void setNeedDays(Integer needDays)
    {
        this.needDays = needDays;
    }

    public Integer getWorkDays()
    {
        return workDays;
    }

    public void setWorkDays(Integer workDays)
    {
        this.workDays = workDays;
    }

    public Integer getRestDays()
    {
        return restDays;
    }

    public void setRestDays(Integer restDays)
    {
        this.restDays = restDays;
    }

    public Integer getLateCount()
    {
        return lateCount;
    }

    public void setLateCount(Integer lateCount)
    {
        this.lateCount = lateCount;
    }

    public Integer getEarlyCount()
    {
        return earlyCount;
    }

    public void setEarlyCount(Integer earlyCount)
    {
        this.earlyCount = earlyCount;
    }

    public Integer getMissCardCount()
    {
        return missCardCount;
    }

    public void setMissCardCount(Integer missCardCount)
    {
        this.missCardCount = missCardCount;
    }

    public Integer getAbsentCount()
    {
        return absentCount;
    }

    public void setAbsentCount(Integer absentCount)
    {
        this.absentCount = absentCount;
    }

    public Integer getActualMinutes()
    {
        return actualMinutes;
    }

    public void setActualMinutes(Integer actualMinutes)
    {
        this.actualMinutes = actualMinutes;
    }
}
