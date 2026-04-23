package com.ruoyi.system.mapper.hr;

import java.time.LocalDateTime;
import java.util.List;
import com.ruoyi.system.domain.hr.HrAttendanceRecord;

public interface HrAttendanceRecordMapper
{
    int insertHrAttendanceRecord(HrAttendanceRecord record);
    List<HrAttendanceRecord> selectByUserAndRange(Long userId, LocalDateTime begin, LocalDateTime end);
}
