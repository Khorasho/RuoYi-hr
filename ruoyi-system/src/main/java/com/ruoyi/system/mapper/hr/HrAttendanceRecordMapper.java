package com.ruoyi.system.mapper.hr;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ruoyi.system.domain.hr.HrAttendanceRecord;

public interface HrAttendanceRecordMapper
{
    int insertHrAttendanceRecord(HrAttendanceRecord record);

    int updateHrAttendanceRecord(HrAttendanceRecord record);

    HrAttendanceRecord selectHrAttendanceRecordById(Long recordId);

    List<HrAttendanceRecord> selectHrAttendanceRecordList(HrAttendanceRecord query);

    List<HrAttendanceRecord> selectByUserAndRange(@Param("userId") Long userId, @Param("begin") LocalDateTime begin, @Param("end") LocalDateTime end);

    int deleteByRangeAndSource(@Param("begin") LocalDateTime begin, @Param("end") LocalDateTime end, @Param("sourceType") String sourceType);

    int deleteAllRecords();
}
