package com.ruoyi.system.domain.hr;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrEmployeeSetting extends BaseEntity
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

    private Long postId;

    @Excel(name = "岗位")
    private String postName;

    @Excel(name = "手机号")
    private String phonenumber;

    private String userStatus;

    @Excel(name = "入职日期", width = 30, dateFormat = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date entryDate;

    @Excel(name = "离职日期", width = 30, dateFormat = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date leaveDate;

    @Excel(name = "轮班起算日期", width = 30, dateFormat = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date rotationAnchorDate;

    private Long defaultShiftId;

    @Excel(name = "默认班次")
    private String defaultShiftName;

    @Excel(name = "参与考勤", readConverterExp = "1=是,0=否")
    private String attendanceEnabled;

    @Excel(name = "备注")
    private String remark;

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

    public Long getPostId()
    {
        return postId;
    }

    public void setPostId(Long postId)
    {
        this.postId = postId;
    }

    public String getPostName()
    {
        return postName;
    }

    public void setPostName(String postName)
    {
        this.postName = postName;
    }

    public String getPhonenumber()
    {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber)
    {
        this.phonenumber = phonenumber;
    }

    public String getUserStatus()
    {
        return userStatus;
    }

    public void setUserStatus(String userStatus)
    {
        this.userStatus = userStatus;
    }

    public Date getEntryDate()
    {
        return entryDate;
    }

    public void setEntryDate(Date entryDate)
    {
        this.entryDate = entryDate;
    }

    public Date getLeaveDate()
    {
        return leaveDate;
    }

    public void setLeaveDate(Date leaveDate)
    {
        this.leaveDate = leaveDate;
    }

    public Date getRotationAnchorDate()
    {
        return rotationAnchorDate;
    }

    public void setRotationAnchorDate(Date rotationAnchorDate)
    {
        this.rotationAnchorDate = rotationAnchorDate;
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

    public String getAttendanceEnabled()
    {
        return attendanceEnabled;
    }

    public void setAttendanceEnabled(String attendanceEnabled)
    {
        this.attendanceEnabled = attendanceEnabled;
    }

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }
}
