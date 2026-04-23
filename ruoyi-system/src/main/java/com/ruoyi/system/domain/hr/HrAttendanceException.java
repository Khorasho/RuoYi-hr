package com.ruoyi.system.domain.hr;

import java.time.LocalDate;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrAttendanceException extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long exceptionId;
    private Long userId;
    private LocalDate workDate;
    private String exceptionType;
    private String exceptionDetail;

    public Long getExceptionId() { return exceptionId; }
    public void setExceptionId(Long exceptionId) { this.exceptionId = exceptionId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public LocalDate getWorkDate() { return workDate; }
    public void setWorkDate(LocalDate workDate) { this.workDate = workDate; }
    public String getExceptionType() { return exceptionType; }
    public void setExceptionType(String exceptionType) { this.exceptionType = exceptionType; }
    public String getExceptionDetail() { return exceptionDetail; }
    public void setExceptionDetail(String exceptionDetail) { this.exceptionDetail = exceptionDetail; }
}
