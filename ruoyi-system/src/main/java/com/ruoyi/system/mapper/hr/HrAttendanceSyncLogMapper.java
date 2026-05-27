package com.ruoyi.system.mapper.hr;

import java.util.List;

import com.ruoyi.system.domain.hr.HrAttendanceSyncLog;

public interface HrAttendanceSyncLogMapper
{
    int insertHrAttendanceSyncLog(HrAttendanceSyncLog log);

    int updateHrAttendanceSyncLog(HrAttendanceSyncLog log);

    List<HrAttendanceSyncLog> selectHrAttendanceSyncLogList(HrAttendanceSyncLog query);
}
