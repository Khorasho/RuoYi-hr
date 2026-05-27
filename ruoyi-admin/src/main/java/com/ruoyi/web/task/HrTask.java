package com.ruoyi.web.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.system.service.hr.IHrAttendanceService;
import com.ruoyi.system.service.hr.IHrScheduleService;

@Component("hrTask")
public class HrTask
{
    @Autowired
    private IHrScheduleService scheduleService;

    @Autowired
    private IHrAttendanceService attendanceService;

    public void syncFutureSevenDaysSchedule()
    {
        scheduleService.syncFutureSchedule(7, "quartz");
    }

    public void syncFutureSevenDaysAttendance()
    {
        attendanceService.syncFutureAttendance(7, "quartz");
    }

    public void syncFutureSchedule(String days)
    {
        int futureDays = parseDays(days);
        scheduleService.syncFutureSchedule(futureDays, "quartz");
    }

    public void syncFutureAttendance(String days)
    {
        int futureDays = parseDays(days);
        attendanceService.syncFutureAttendance(futureDays, "quartz");
    }

    private int parseDays(String days)
    {
        try
        {
            return Integer.parseInt(days);
        }
        catch (Exception ex)
        {
            return 7;
        }
    }
}
