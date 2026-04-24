package com.ruoyi.system.mapper.hr;

import java.time.LocalDate;
import java.util.List;
import com.ruoyi.system.domain.hr.HrSchedule;

public interface HrScheduleMapper
{
    List<HrSchedule> selectHrScheduleList(HrSchedule schedule);
    HrSchedule selectHrScheduleById(Long scheduleId);
    int insertHrSchedule(HrSchedule schedule);
    int updateHrSchedule(HrSchedule schedule);
    int deleteHrScheduleByIds(Long[] ids);
    int deleteByUserAndDate(Long userId, LocalDate workDate);
    int countByUserAndDate(Long userId, LocalDate workDate);
    List<HrSchedule> selectByDate(LocalDate workDate);
}
