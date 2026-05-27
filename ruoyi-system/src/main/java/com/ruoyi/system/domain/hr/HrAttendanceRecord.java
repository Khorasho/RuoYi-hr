package com.ruoyi.system.domain.hr;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long recordId;

    private Long userId;

    @Excel(name = "工号")
    private String loginName;

    @Excel(name = "姓名")
    private String userName;

    private Long deptIdSnapshot;

    @Excel(name = "部门")
    private String deptNameSnapshot;

    @Excel(name = "设备工号")
    private String deviceUserNo;

    @Excel(name = "打卡时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime punchTime;

    @Excel(name = "数据来源")
    private String sourceType;

    @Excel(name = "设备名称")
    private String deviceName;

    @Excel(name = "设备编号")
    private String deviceNo;

    @Excel(name = "设备区域")
    private String deviceArea;

    @Excel(name = "打卡类型")
    private String punchType;

    @Excel(name = "同步批次号")
    private String syncBatchNo;

    @Excel(name = "同步时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime syncTime;

    @Excel(name = "记录状态")
    private String recordStatus;

    @Excel(name = "作废原因")
    private String invalidReason;

    private String sourceDbKey;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

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

    public Long getDeptIdSnapshot()
    {
        return deptIdSnapshot;
    }

    public void setDeptIdSnapshot(Long deptIdSnapshot)
    {
        this.deptIdSnapshot = deptIdSnapshot;
    }

    public String getDeptNameSnapshot()
    {
        return deptNameSnapshot;
    }

    public void setDeptNameSnapshot(String deptNameSnapshot)
    {
        this.deptNameSnapshot = deptNameSnapshot;
    }

    public String getDeviceUserNo()
    {
        return deviceUserNo;
    }

    public void setDeviceUserNo(String deviceUserNo)
    {
        this.deviceUserNo = deviceUserNo;
    }

    public LocalDateTime getPunchTime()
    {
        return punchTime;
    }

    public void setPunchTime(LocalDateTime punchTime)
    {
        this.punchTime = punchTime;
    }

    public String getSourceType()
    {
        return sourceType;
    }

    public void setSourceType(String sourceType)
    {
        this.sourceType = sourceType;
    }

    public String getDeviceName()
    {
        return deviceName;
    }

    public void setDeviceName(String deviceName)
    {
        this.deviceName = deviceName;
    }

    public String getDeviceNo()
    {
        return deviceNo;
    }

    public void setDeviceNo(String deviceNo)
    {
        this.deviceNo = deviceNo;
    }

    public String getDeviceArea()
    {
        return deviceArea;
    }

    public void setDeviceArea(String deviceArea)
    {
        this.deviceArea = deviceArea;
    }

    public String getPunchType()
    {
        return punchType;
    }

    public void setPunchType(String punchType)
    {
        this.punchType = punchType;
    }

    public String getSyncBatchNo()
    {
        return syncBatchNo;
    }

    public void setSyncBatchNo(String syncBatchNo)
    {
        this.syncBatchNo = syncBatchNo;
    }

    public LocalDateTime getSyncTime()
    {
        return syncTime;
    }

    public void setSyncTime(LocalDateTime syncTime)
    {
        this.syncTime = syncTime;
    }

    public String getRecordStatus()
    {
        return recordStatus;
    }

    public void setRecordStatus(String recordStatus)
    {
        this.recordStatus = recordStatus;
    }

    public String getInvalidReason()
    {
        return invalidReason;
    }

    public void setInvalidReason(String invalidReason)
    {
        this.invalidReason = invalidReason;
    }

    public String getSourceDbKey()
    {
        return sourceDbKey;
    }

    public void setSourceDbKey(String sourceDbKey)
    {
        this.sourceDbKey = sourceDbKey;
    }
}
