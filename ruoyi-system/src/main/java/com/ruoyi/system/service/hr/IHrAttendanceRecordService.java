package com.ruoyi.system.service.hr;

import java.util.List;

import com.ruoyi.system.domain.hr.HrAttendanceRecord;
import com.ruoyi.system.domain.hr.HrAttendanceSyncLog;

public interface IHrAttendanceRecordService
{
    List<HrAttendanceRecord> selectAttendanceRecordList(HrAttendanceRecord query);

    List<HrAttendanceSyncLog> selectAttendanceSyncLogList(HrAttendanceSyncLog query);

    HrAttendanceSyncLog triggerDeviceSync(String operator);
}
