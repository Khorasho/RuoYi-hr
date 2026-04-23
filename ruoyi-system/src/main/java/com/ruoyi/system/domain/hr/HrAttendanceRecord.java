package com.ruoyi.system.domain.hr;

import java.time.LocalDateTime;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long recordId;
    private Long userId;
    private String deviceUserNo;
    private LocalDateTime punchTime;
    private String sourceType;

    public Long getRecordId() { return recordId; }
    public void setRecordId(Long recordId) { this.recordId = recordId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getDeviceUserNo() { return deviceUserNo; }
    public void setDeviceUserNo(String deviceUserNo) { this.deviceUserNo = deviceUserNo; }
    public LocalDateTime getPunchTime() { return punchTime; }
    public void setPunchTime(LocalDateTime punchTime) { this.punchTime = punchTime; }
    public String getSourceType() { return sourceType; }
    public void setSourceType(String sourceType) { this.sourceType = sourceType; }
}
