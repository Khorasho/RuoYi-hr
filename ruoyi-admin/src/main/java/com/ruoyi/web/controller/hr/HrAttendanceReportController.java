package com.ruoyi.web.controller.hr;

import java.time.LocalDate;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrAttendanceReportQuery;
import com.ruoyi.system.domain.hr.HrDeptAttendanceReport;
import com.ruoyi.system.domain.hr.HrUserAttendanceReport;
import com.ruoyi.system.service.ISysDeptService;
import com.ruoyi.system.service.hr.IHrAttendanceService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/hr/report")
public class HrAttendanceReportController extends BaseController
{
    private static final String PREFIX = "hr/report";

    @Autowired
    private IHrAttendanceService attendanceService;

    @Autowired
    private ISysDeptService deptService;

    @RequiresPermissions("hr:report:view")
    @GetMapping("/month")
    public String month(ModelMap mmap)
    {
        mmap.put("defaultMonth", LocalDate.now().withDayOfMonth(1).toString().substring(0, 7));
        return PREFIX + "/month";
    }

    @RequiresPermissions("hr:report:view")
    @GetMapping("/year")
    public String year(ModelMap mmap)
    {
        mmap.put("defaultYear", String.valueOf(LocalDate.now().getYear()));
        return PREFIX + "/year";
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/month/dept/list")
    @ResponseBody
    public AjaxResult monthDeptList(HrAttendanceReportQuery query)
    {
        normalizeMonth(query);
        AjaxResult result = AjaxResult.success();
        result.put("rows", attendanceService.selectMonthDeptReport(query));
        return result;
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/month/user/list")
    @ResponseBody
    public TableDataInfo monthUserList(HrAttendanceReportQuery query)
    {
        normalizeMonth(query);
        startPage();
        return getDataTable(attendanceService.selectMonthUserReport(query));
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/month/dept/export")
    @ResponseBody
    public AjaxResult exportMonthDept(HrAttendanceReportQuery query)
    {
        normalizeMonth(query);
        ExcelUtil<HrDeptAttendanceReport> util = new ExcelUtil<>(HrDeptAttendanceReport.class);
        return util.exportExcel(attendanceService.selectMonthDeptReport(query), buildMonthDeptExportName(query));
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/month/user/export")
    @ResponseBody
    public AjaxResult exportMonthUser(HrAttendanceReportQuery query)
    {
        normalizeMonth(query);
        ExcelUtil<HrUserAttendanceReport> util = new ExcelUtil<>(HrUserAttendanceReport.class);
        return util.exportExcel(attendanceService.selectMonthUserReport(query), query.getMonth() + "_个人月汇总");
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/year/dept/list")
    @ResponseBody
    public AjaxResult yearDeptList(HrAttendanceReportQuery query)
    {
        normalizeYear(query);
        AjaxResult result = AjaxResult.success();
        result.put("rows", attendanceService.selectYearDeptReport(query));
        return result;
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/year/user/list")
    @ResponseBody
    public TableDataInfo yearUserList(HrAttendanceReportQuery query)
    {
        normalizeYear(query);
        startPage();
        return getDataTable(attendanceService.selectYearUserReport(query));
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/year/dept/export")
    @ResponseBody
    public AjaxResult exportYearDept(HrAttendanceReportQuery query)
    {
        normalizeYear(query);
        ExcelUtil<HrDeptAttendanceReport> util = new ExcelUtil<>(HrDeptAttendanceReport.class);
        return util.exportExcel(attendanceService.selectYearDeptReport(query), buildYearDeptExportName(query));
    }

    @RequiresPermissions("hr:report:view")
    @PostMapping("/year/user/export")
    @ResponseBody
    public AjaxResult exportYearUser(HrAttendanceReportQuery query)
    {
        normalizeYear(query);
        ExcelUtil<HrUserAttendanceReport> util = new ExcelUtil<>(HrUserAttendanceReport.class);
        return util.exportExcel(attendanceService.selectYearUserReport(query), query.getYear() + "_个人年度汇总");
    }

    private void normalizeMonth(HrAttendanceReportQuery query)
    {
        if (query.getMonth() == null || !query.getMonth().matches("\\d{4}-\\d{2}"))
        {
            query.setMonth(LocalDate.now().withDayOfMonth(1).toString().substring(0, 7));
        }
    }

    private void normalizeYear(HrAttendanceReportQuery query)
    {
        if (query.getYear() == null || !query.getYear().matches("\\d{4}"))
        {
            query.setYear(String.valueOf(LocalDate.now().getYear()));
        }
    }

    private String buildMonthDeptExportName(HrAttendanceReportQuery query)
    {
        return query.getMonth() + "_" + resolveDeptExportName(query.getDeptId()) + "_部门月汇总";
    }

    private String buildYearDeptExportName(HrAttendanceReportQuery query)
    {
        return query.getYear() + "_" + resolveDeptExportName(query.getDeptId()) + "_部门年度汇总";
    }

    private String resolveDeptExportName(Long deptId)
    {
        if (deptId == null)
        {
            return "全部部门";
        }
        SysDept dept = deptService.selectDeptById(deptId);
        if (dept == null || dept.getDeptName() == null || dept.getDeptName().trim().isEmpty())
        {
            return "全部部门";
        }
        return dept.getDeptName().trim();
    }
}
