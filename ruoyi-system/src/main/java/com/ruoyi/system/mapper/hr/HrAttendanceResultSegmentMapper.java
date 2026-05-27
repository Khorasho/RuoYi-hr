package com.ruoyi.system.mapper.hr;

import java.time.LocalDate;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.hr.HrAttendanceResultSegment;

public interface HrAttendanceResultSegmentMapper
{
    int insertHrAttendanceResultSegment(HrAttendanceResultSegment segment);

    int deleteByDateRange(@Param("beginDate") LocalDate beginDate, @Param("endDate") LocalDate endDate);

    int deleteByResultId(@Param("resultId") Long resultId);

    List<HrAttendanceResultSegment> selectByResultId(@Param("resultId") Long resultId);
}