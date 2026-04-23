package com.ruoyi.web.controller.hr;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrAttendanceResult;
import com.ruoyi.system.service.hr.IHrAttendanceService;

@Controller
@RequestMapping("/hr/attendance")
public class HrAttendanceController extends BaseController
{
    private final String prefix = "hr/attendance";

    @Autowired
    private IHrAttendanceService attendanceService;

    @RequiresPermissions("hr:attendance:view")
    @GetMapping()
    public String attendance()
    {
        return prefix + "/attendance";
    }

    @RequiresPermissions("hr:attendance:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(HrAttendanceResult query)
    {
        startPage();
        return getDataTable(attendanceService.selectAttendanceResultList(query));
    }

    @RequiresPermissions("hr:attendance:recalc")
    @Log(title = "HR考勤重算", businessType = BusinessType.OTHER)
    @PostMapping("/recalculateDay")
    @ResponseBody
    public AjaxResult recalculateDay(@RequestParam String workDate)
    {
        int rows = attendanceService.recalculateDay(LocalDate.parse(workDate), getLoginName());
        return AjaxResult.success("重算完成，处理记录: " + rows);
    }

    @RequiresPermissions("hr:attendance:recalc")
    @Log(title = "HR考勤重算", businessType = BusinessType.OTHER)
    @PostMapping("/recalculateMonth")
    @ResponseBody
    public AjaxResult recalculateMonth(@RequestParam String month)
    {
        int rows = attendanceService.recalculateMonth(month, getLoginName());
        return AjaxResult.success("月重算完成，处理记录: " + rows);
    }

    @RequiresPermissions("hr:attendance:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(HrAttendanceResult query)
    {
        ExcelUtil<HrAttendanceResult> util = new ExcelUtil<>(HrAttendanceResult.class);
        return util.exportExcel(attendanceService.selectAttendanceResultList(query), "考勤结果");
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
}
