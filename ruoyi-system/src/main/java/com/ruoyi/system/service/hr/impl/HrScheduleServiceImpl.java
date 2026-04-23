package com.ruoyi.system.service.hr.impl;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.mapper.hr.HrScheduleMapper;
import com.ruoyi.system.service.hr.IHrScheduleService;

@Service
public class HrScheduleServiceImpl implements IHrScheduleService
{
    @Autowired
    private HrScheduleMapper scheduleMapper;

    @Override
    public List<HrSchedule> selectHrScheduleList(HrSchedule schedule)
    {
        return scheduleMapper.selectHrScheduleList(schedule);
    }

    @Override
    public HrSchedule selectHrScheduleById(Long scheduleId)
    {
        return scheduleMapper.selectHrScheduleById(scheduleId);
    }

    @Override
    public int insertHrSchedule(HrSchedule schedule, boolean overwrite)
    {
        if (overwrite && schedule.getUserId() != null && schedule.getWorkDate() != null)
        {
            LocalDate workDate = schedule.getWorkDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            scheduleMapper.deleteByUserAndDate(schedule.getUserId(), workDate);
        }
        return scheduleMapper.insertHrSchedule(schedule);
    }

    @Override
    public int updateHrSchedule(HrSchedule schedule)
    {
        return scheduleMapper.updateHrSchedule(schedule);
    }

    @Override
    public int deleteHrScheduleByIds(String ids)
    {
        return scheduleMapper.deleteHrScheduleByIds(Convert.toLongArray(ids));
    }
}
