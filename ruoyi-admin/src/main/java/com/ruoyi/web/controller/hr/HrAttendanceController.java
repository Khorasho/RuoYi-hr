package com.ruoyi.web.controller.hr;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrAttendanceRecord;
import com.ruoyi.system.domain.hr.HrAttendanceResult;
import com.ruoyi.system.domain.hr.HrAttendanceResultSegment;
import com.ruoyi.system.service.hr.IHrAttendanceRecordService;
import com.ruoyi.system.service.hr.IHrAttendanceService;
import com.ruoyi.system.service.hr.IHrEmployeeSettingService;
import com.ruoyi.system.service.hr.IHrScheduleService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.UriComponentsBuilder;

@Controller
@RequestMapping("/hr/attendance")
public class HrAttendanceController extends BaseController
{
    private static final String PREFIX = "hr/attendance";

    @Autowired
    private IHrAttendanceService attendanceService;

    @Autowired
    private IHrScheduleService scheduleService;

    @Autowired
    private IHrEmployeeSettingService employeeSettingService;

    @Autowired
    private IHrAttendanceRecordService attendanceRecordService;

    @RequiresPermissions("hr:attendance:view")
    @GetMapping()
    public String attendance()
    {
        return PREFIX + "/attendance";
    }

    @RequiresPermissions("hr:attendance:view")
    @GetMapping("/detail/{resultId}")
    public String detail(@PathVariable("resultId") Long resultId, ModelMap mmap)
    {
        HrAttendanceResult result = attendanceService.selectAttendanceResultById(resultId);
        if (result == null)
        {
            mmap.put("result", new HrAttendanceResult());
            mmap.put("segments", List.of());
            mmap.put("records", List.of());
            return PREFIX + "/detail";
        }
        List<HrAttendanceResultSegment> segments = attendanceService.selectAttendanceResultSegments(resultId);
        List<HrAttendanceRecord> records = attendanceService.selectAttendancePunchRecords(result.getUserId(), result.getWorkDate());
        mmap.put("result", result);
        mmap.put("segments", segments);
        mmap.put("records", records);
        return PREFIX + "/detail";
    }

    @RequiresPermissions("hr:attendance:view")
    @GetMapping("/punchRecord/{resultId}")
    public String punchRecord(@PathVariable("resultId") Long resultId)
    {
        HrAttendanceResult result = attendanceService.selectAttendanceResultById(resultId);
        if (result == null || result.getWorkDate() == null)
        {
            return "redirect:/hr/attendanceRecord";
        }
        LocalDate beginDate = result.getWorkDate();
        LocalDate endDate = result.getWorkDate();
        if (result.getExpectedOutTime() != null && result.getExpectedOutTime().toLocalDate().isAfter(endDate))
        {
            endDate = result.getExpectedOutTime().toLocalDate();
        }
        return "redirect:" + UriComponentsBuilder.fromPath("/hr/attendanceRecord")
            .queryParam("userId", result.getUserId())
            .queryParam("loginName", result.getLoginName())
            .queryParam("userName", result.getUserName())
            .queryParam("beginTime", beginDate + " 00:00:00")
            .queryParam("endTime", endDate + " 23:59:59")
            .build()
            .encode()
            .toUriString();
    }

    @RequiresPermissions("hr:attendance:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(HrAttendanceResult query)
    {
        startPage();
        return getDataTable(attendanceService.selectAttendanceResultList(query));
    }

    @RequiresPermissions("hr:attendance:generate")
    @Log(title = "考勤明细生成", businessType = BusinessType.OTHER)
    @PostMapping("/generateMonthly")
    @ResponseBody
    public AjaxResult generateMonthly(@RequestParam String month)
    {
        int configuredUsers = employeeSettingService.countConfiguredAttendanceUsers();
        if (configuredUsers <= 0)
        {
            return AjaxResult.error("未找到可生成考勤的员工设置，请先在员工设置中维护入职日期、默认班次和参与考勤");
        }
        int scheduleRows = scheduleService.generateMonthlySchedule(month, null, null, true, getLoginName());
        if (scheduleRows <= 0)
        {
            return AjaxResult.error("该月份未生成任何排班，请先检查员工设置、默认班次和在职日期范围");
        }
        int rows = attendanceService.generateMonthly(month, getLoginName());
        return AjaxResult.success("考勤明细生成完成，共处理 " + rows + " 条记录");
    }

    @RequiresPermissions("hr:attendance:generate")
    @Log(title = "演示打卡生成", businessType = BusinessType.OTHER)
    @PostMapping("/generateDemoPunches")
    @ResponseBody
    public AjaxResult generateDemoPunches(@RequestParam String month)
    {
        int configuredUsers = employeeSettingService.countConfiguredAttendanceUsers();
        if (configuredUsers <= 0)
        {
            return AjaxResult.error("未找到可生成演示打卡的员工设置，请先在员工设置中维护入职日期、默认班次和参与考勤");
        }
        scheduleService.generateMonthlySchedule(month, null, null, true, getLoginName());
        int rows = attendanceService.generateDemoPunches(month, getLoginName());
        if (rows <= 0)
        {
            return AjaxResult.error("该月份没有生成任何演示打卡，请先检查排班数据是否存在");
        }
        return AjaxResult.success("演示打卡生成完成，并已同步刷新考勤明细，共写入 " + rows + " 条打卡记录");
    }

    @RequiresPermissions("hr:attendance:generate")
    @Log(title = "考勤机同步", businessType = BusinessType.OTHER)
    @PostMapping("/syncDevicePunches")
    @ResponseBody
    public AjaxResult syncDevicePunches()
    {
        String batchNo = attendanceRecordService.triggerDeviceSync(getLoginName()).getBatchNo();
        AjaxResult result = AjaxResult.success("已发起考勤机同步，当前为预留模式，批次号：" + batchNo);
        result.put("batchNo", batchNo);
        return result;
    }

    @RequiresPermissions("hr:attendance:recalc")
    @Log(title = "考勤明细日重算", businessType = BusinessType.OTHER)
    @PostMapping("/recalculateDay")
    @ResponseBody
    public AjaxResult recalculateDay(@RequestParam String workDate)
    {
        int rows = attendanceService.recalculateDay(LocalDate.parse(workDate), getLoginName());
        return AjaxResult.success("日重算完成，处理记录 " + rows);
    }

    @RequiresPermissions("hr:attendance:recalc")
    @Log(title = "考勤明细月重算", businessType = BusinessType.OTHER)
    @PostMapping("/recalculateMonth")
    @ResponseBody
    public AjaxResult recalculateMonth(@RequestParam String month)
    {
        int rows = attendanceService.recalculateMonth(month, getLoginName());
        return AjaxResult.success("月重算完成，处理记录 " + rows);
    }

    @RequiresPermissions("hr:attendance:recalc")
    @Log(title = "未来七天考勤同步", businessType = BusinessType.OTHER)
    @PostMapping("/syncFutureSevenDays")
    @ResponseBody
    public AjaxResult syncFutureSevenDays()
    {
        int rows = attendanceService.syncFutureAttendance(7, getLoginName());
        return AjaxResult.success("未来7天考勤明细同步完成，共处理 " + rows + " 条记录");
    }

    @RequiresPermissions("hr:attendance:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(HrAttendanceResult query)
    {
        ExcelUtil<HrAttendanceResult> util = new ExcelUtil<>(HrAttendanceResult.class);
        return util.exportExcel(attendanceService.selectAttendanceResultList(query), "考勤明细");
    }

    @RequiresPermissions("hr:report:view")
    @GetMapping("/monthSummary")
    @ResponseBody
    public AjaxResult monthSummary(@RequestParam String month,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long userId)
    {
        List<Map<String, Object>> dept = attendanceService.selectMonthDeptSummary(month, deptId, userId);
        List<Map<String, Object>> user = attendanceService.selectMonthUserSummary(month, deptId, userId);
        AjaxResult result = AjaxResult.success();
        result.put("deptSummary", dept);
        result.put("userSummary", user);
        return result;
    }

    @RequiresPermissions("hr:report:view")
    @GetMapping("/yearSummary")
    @ResponseBody
    public AjaxResult yearSummary(@RequestParam String year,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long userId)
    {
        List<Map<String, Object>> dept = attendanceService.selectYearDeptSummary(year, deptId, userId);
        List<Map<String, Object>> user = attendanceService.selectYearUserSummary(year, deptId, userId);
        AjaxResult result = AjaxResult.success();
        result.put("deptSummary", dept);
        result.put("userSummary", user);
        return result;
    }
}
