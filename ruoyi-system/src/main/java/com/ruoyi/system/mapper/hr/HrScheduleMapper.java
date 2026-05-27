package com.ruoyi.system.mapper.hr;

import java.time.LocalDate;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.hr.HrSchedule;

public interface HrScheduleMapper
{
    List<HrSchedule> selectHrScheduleList(HrSchedule schedule);

    HrSchedule selectHrScheduleById(Long scheduleId);

    int insertHrSchedule(HrSchedule schedule);

    int updateHrSchedule(HrSchedule schedule);

    int deleteHrScheduleByIds(Long[] ids);

    int deleteByUserAndDate(@Param("userId") Long userId, @Param("workDate") LocalDate workDate);

    int deleteByUserAndRange(@Param("userId") Long userId, @Param("beginDate") LocalDate beginDate, @Param("endDate") LocalDate endDate);

    int countByUserAndDate(@Param("userId") Long userId, @Param("workDate") LocalDate workDate);

    int countByUserAndDateExcludeId(@Param("scheduleId") Long scheduleId, @Param("userId") Long userId, @Param("workDate") LocalDate workDate);

    List<LocalDate> selectWorkDatesByUserAndRange(@Param("userId") Long userId, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    List<HrSchedule> selectByUserAndRange(@Param("userId") Long userId, @Param("beginDate") LocalDate beginDate, @Param("endDate") LocalDate endDate);

    List<HrSchedule> selectByDate(LocalDate workDate);

    List<HrSchedule> selectByDateRange(@Param("beginDate") LocalDate beginDate, @Param("endDate") LocalDate endDate);

    HrSchedule selectByUserAndDate(@Param("userId") Long userId, @Param("workDate") LocalDate workDate);

    List<HrSchedule> selectByShiftId(Long shiftId);

    int deleteByShiftAndUser(@Param("shiftId") Long shiftId, @Param("userId") Long userId);
}
