package com.ruoyi.system.domain.hr;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrSchedule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long scheduleId;
    @Excel(name = "用户ID")
    private Long userId;
    @Excel(name = "员工")
    private String userName;
    @Excel(name = "部门ID")
    private Long deptId;
    @Excel(name = "部门")
    private String deptName;
    @Excel(name = "排班日期", width = 30, dateFormat = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date workDate;
    @Excel(name = "班次ID")
    private Long shiftId;
    @Excel(name = "班次")
    private String shiftName;
    @Excel(name = "休息类型")
    private String restType;
    @Excel(name = "备注")
    private String scheduleRemark;

    public Long getScheduleId() { return scheduleId; }
    public void setScheduleId(Long scheduleId) { this.scheduleId = scheduleId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public Date getWorkDate() { return workDate; }
    public void setWorkDate(Date workDate) { this.workDate = workDate; }
    public Long getShiftId() { return shiftId; }
    public void setShiftId(Long shiftId) { this.shiftId = shiftId; }
    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }
    public String getRestType() { return restType; }
    public void setRestType(String restType) { this.restType = restType; }
    public String getScheduleRemark() { return scheduleRemark; }
    public void setScheduleRemark(String scheduleRemark) { this.scheduleRemark = scheduleRemark; }
}
