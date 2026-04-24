package com.ruoyi.system.domain.hr;

import java.util.Date;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrEmployee extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long hrEmployeeId;

    @Excel(name = "用户ID")
    private Long userId;

    @Excel(name = "部门ID")
    private Long deptId;

    @Excel(name = "工号")
    private String employeeNo;

    @Excel(name = "工种")
    private String jobType;

    @Excel(name = "是否参与考勤", readConverterExp = "1=是,0=否")
    private String attendEnabled;

    @Excel(name = "默认班组")
    private String defaultShiftGroup;
    
    private Long defaultShiftId;
    
    private String defaultShiftName;

    @Excel(name = "设备工号")
    private String deviceUserNo;

    @Excel(name = "入职日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date joinDate;

    @Excel(name = "在职状态", readConverterExp = "0=在职,1=离职")
    private String workStatus;

    private String delFlag;

    private String userName;

    private String deptName;

    public Long getHrEmployeeId()
    {
        return hrEmployeeId;
    }

    public void setHrEmployeeId(Long hrEmployeeId)
    {
        this.hrEmployeeId = hrEmployeeId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public String getEmployeeNo()
    {
        return employeeNo;
    }

    public void setEmployeeNo(String employeeNo)
    {
        this.employeeNo = employeeNo;
    }

    public String getJobType()
    {
        return jobType;
    }

    public void setJobType(String jobType)
    {
        this.jobType = jobType;
    }

    public String getAttendEnabled()
    {
        return attendEnabled;
    }

    public void setAttendEnabled(String attendEnabled)
    {
        this.attendEnabled = attendEnabled;
    }

    public String getDefaultShiftGroup()
    {
        return defaultShiftGroup;
    }

    public void setDefaultShiftGroup(String defaultShiftGroup)
    {
        this.defaultShiftGroup = defaultShiftGroup;
    }
    
    public Long getDefaultShiftId()
    {
        return defaultShiftId;
    }

    public void setDefaultShiftId(Long defaultShiftId)
    {
        this.defaultShiftId = defaultShiftId;
    }
    
    public String getDefaultShiftName()
    {
        return defaultShiftName;
    }

    public void setDefaultShiftName(String defaultShiftName)
    {
        this.defaultShiftName = defaultShiftName;
    }

    public String getDeviceUserNo()
    {
        return deviceUserNo;
    }

    public void setDeviceUserNo(String deviceUserNo)
    {
        this.deviceUserNo = deviceUserNo;
    }

    public Date getJoinDate()
    {
        return joinDate;
    }

    public void setJoinDate(Date joinDate)
    {
        this.joinDate = joinDate;
    }

    public String getWorkStatus()
    {
        return workStatus;
    }

    public void setWorkStatus(String workStatus)
    {
        this.workStatus = workStatus;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }
}
