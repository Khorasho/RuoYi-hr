package com.ruoyi.system.service.hr.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ruoyi.system.domain.hr.HrAttendanceRecord;
import com.ruoyi.system.domain.hr.HrAttendanceSyncLog;
import com.ruoyi.system.mapper.hr.HrAttendanceRecordMapper;
import com.ruoyi.system.mapper.hr.HrAttendanceSyncLogMapper;
import com.ruoyi.system.service.hr.IHrAttendanceRecordService;

@Service
public class HrAttendanceRecordServiceImpl implements IHrAttendanceRecordService
{
    private static final DateTimeFormatter BATCH_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    @Autowired
    private HrAttendanceRecordMapper attendanceRecordMapper;

    @Autowired
    private HrAttendanceSyncLogMapper attendanceSyncLogMapper;

    @Override
    public List<HrAttendanceRecord> selectAttendanceRecordList(HrAttendanceRecord query)
    {
        return attendanceRecordMapper.selectHrAttendanceRecordList(query);
    }

    @Override
    public List<HrAttendanceSyncLog> selectAttendanceSyncLogList(HrAttendanceSyncLog query)
    {
        return attendanceSyncLogMapper.selectHrAttendanceSyncLogList(query);
    }

    @Override
    @Transactional
    public HrAttendanceSyncLog triggerDeviceSync(String operator)
    {
        LocalDateTime now = LocalDateTime.now();
        HrAttendanceSyncLog log = new HrAttendanceSyncLog();
        log.setBatchNo("SYNC-" + now.format(BATCH_FORMATTER));
        log.setTriggerType("MANUAL");
        log.setSourceType("DEVICE_DB");
        log.setStatus("SUCCESS");
        log.setStartTime(now);
        log.setEndTime(now);
        log.setTotalCount(0);
        log.setSuccessCount(0);
        log.setFailCount(0);
        log.setMessage("已预留考勤机数据库同步入口，待对方数据库字段确认后接入实际同步。");
        log.setCreateBy(operator);
        attendanceSyncLogMapper.insertHrAttendanceSyncLog(log);
        return log;
    }
}
