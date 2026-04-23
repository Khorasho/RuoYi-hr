package com.ruoyi.system.service.hr;

import java.util.List;
import com.ruoyi.system.domain.hr.HrSchedule;

public interface IHrScheduleService
{
    List<HrSchedule> selectHrScheduleList(HrSchedule schedule);
    HrSchedule selectHrScheduleById(Long scheduleId);
    int insertHrSchedule(HrSchedule schedule, boolean overwrite);
    int updateHrSchedule(HrSchedule schedule);
    int deleteHrScheduleByIds(String ids);
}
