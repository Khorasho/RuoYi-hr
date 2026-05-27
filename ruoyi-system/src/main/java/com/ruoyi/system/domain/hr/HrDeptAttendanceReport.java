package com.ruoyi.system.domain.hr;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrDeptAttendanceReport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long deptId;

    @Excel(name = "部门")
    private String deptName;

    @Excel(name = "应出勤天数")
    private Integer needDays;

    @Excel(name = "实出勤天数")
    private Integer workDays;

    @Excel(name = "休息天数")
    private Integer restDays;

    @Excel(name = "迟到人数")
    private Integer lateUserCount;

    @Excel(name = "早退人数")
    private Integer earlyUserCount;

    @Excel(name = "缺卡人数")
    private Integer missCardUserCount;

    @Excel(name = "旷工人数")
    private Integer absentUserCount;

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

    public Integer getLateUserCount()
    {
        return lateUserCount;
    }

    public void setLateUserCount(Integer lateUserCount)
    {
        this.lateUserCount = lateUserCount;
    }

    public Integer getEarlyUserCount()
    {
        return earlyUserCount;
    }

    public void setEarlyUserCount(Integer earlyUserCount)
    {
        this.earlyUserCount = earlyUserCount;
    }

    public Integer getMissCardUserCount()
    {
        return missCardUserCount;
    }

    public void setMissCardUserCount(Integer missCardUserCount)
    {
        this.missCardUserCount = missCardUserCount;
    }

    public Integer getAbsentUserCount()
    {
        return absentUserCount;
    }

    public void setAbsentUserCount(Integer absentUserCount)
    {
        this.absentUserCount = absentUserCount;
    }
}
