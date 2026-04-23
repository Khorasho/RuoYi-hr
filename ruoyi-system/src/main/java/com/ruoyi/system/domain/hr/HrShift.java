package com.ruoyi.system.domain.hr;

import java.time.LocalTime;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class HrShift extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long shiftId;

    @Excel(name = "班次编码")
    private String shiftCode;

    @Excel(name = "班次名称")
    private String shiftName;

    @Excel(name = "岗位")
    private String postType;

    @Excel(name = "是否夏令时", readConverterExp = "1=是,0=否")
    private String summerExtendEnabled;

    @Excel(name = "下班延长分钟")
    private Integer summerExtendMinutes;

    @Excel(name = "最早上班")
    private LocalTime expectedStartTime;

    @Excel(name = "最晚下班")
    private LocalTime expectedEndTime;

    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    private String delFlag;

    public Long getShiftId() { return shiftId; }
    public void setShiftId(Long shiftId) { this.shiftId = shiftId; }
    public String getShiftCode() { return shiftCode; }
    public void setShiftCode(String shiftCode) { this.shiftCode = shiftCode; }
    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }
    public String getPostType() { return postType; }
    public void setPostType(String postType) { this.postType = postType; }
    public String getSummerExtendEnabled() { return summerExtendEnabled; }
    public void setSummerExtendEnabled(String summerExtendEnabled) { this.summerExtendEnabled = summerExtendEnabled; }
    public Integer getSummerExtendMinutes() { return summerExtendMinutes; }
    public void setSummerExtendMinutes(Integer summerExtendMinutes) { this.summerExtendMinutes = summerExtendMinutes; }
    public LocalTime getExpectedStartTime() { return expectedStartTime; }
    public void setExpectedStartTime(LocalTime expectedStartTime) { this.expectedStartTime = expectedStartTime; }
    public LocalTime getExpectedEndTime() { return expectedEndTime; }
    public void setExpectedEndTime(LocalTime expectedEndTime) { this.expectedEndTime = expectedEndTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
