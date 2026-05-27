package com.ruoyi.system.domain.hr;

import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceReportQuery extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private String month;

    private String year;

    private Long deptId;

    private String loginName;

    private String userName;

    public String getMonth()
    {
        return month;
    }

    public void setMonth(String month)
    {
        this.month = month;
    }

    public String getYear()
    {
        return year;
    }

    public void setYear(String year)
    {
        this.year = year;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
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
}
