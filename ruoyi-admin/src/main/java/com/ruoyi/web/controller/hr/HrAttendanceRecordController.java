package com.ruoyi.web.controller.hr;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrAttendanceRecord;
import com.ruoyi.system.domain.hr.HrAttendanceSyncLog;
import com.ruoyi.system.service.hr.IHrAttendanceRecordService;

@Controller
@RequestMapping("/hr/attendanceRecord")
public class HrAttendanceRecordController extends BaseController
{
    private final String prefix = "hr/attendanceRecord";

    @Autowired
    private IHrAttendanceRecordService attendanceRecordService;

    @RequiresPermissions("hr:attendanceRecord:view")
    @GetMapping()
    public String attendanceRecord()
    {
        return prefix + "/record";
    }

    @RequiresPermissions("hr:attendanceRecord:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(HrAttendanceRecord query)
    {
        startPage();
        return getDataTable(attendanceRecordService.selectAttendanceRecordList(query));
    }

    @RequiresPermissions("hr:attendanceRecord:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(HrAttendanceRecord query)
    {
        ExcelUtil<HrAttendanceRecord> util = new ExcelUtil<>(HrAttendanceRecord.class);
        return util.exportExcel(attendanceRecordService.selectAttendanceRecordList(query), "考勤打卡记录");
    }

    @RequiresPermissions("hr:attendanceRecord:sync")
    @Log(title = "同步考勤机打卡", businessType = BusinessType.OTHER)
    @PostMapping("/syncDevice")
    @ResponseBody
    public AjaxResult syncDevice()
    {
        HrAttendanceSyncLog log = attendanceRecordService.triggerDeviceSync(getLoginName());
        AjaxResult result = AjaxResult.success("已发起考勤机同步，当前为预留模式，批次号：" + log.getBatchNo());
        result.put("batchNo", log.getBatchNo());
        return result;
    }

    @RequiresPermissions("hr:attendanceSync:view")
    @GetMapping("/syncLog")
    public String syncLog()
    {
        return prefix + "/syncLog";
    }

    @RequiresPermissions("hr:attendanceSync:list")
    @PostMapping("/syncLog/list")
    @ResponseBody
    public TableDataInfo syncLogList(HrAttendanceSyncLog query)
    {
        startPage();
        return getDataTable(attendanceRecordService.selectAttendanceSyncLogList(query));
    }
}
