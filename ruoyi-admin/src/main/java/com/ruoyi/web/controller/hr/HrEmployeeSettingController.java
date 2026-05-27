package com.ruoyi.web.controller.hr;

import java.time.LocalDate;
import org.springframework.web.bind.annotation.RequestParam;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrEmployeeSetting;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.service.ISysPostService;
import com.ruoyi.system.service.hr.IHrEmployeeSettingService;
import com.ruoyi.system.service.hr.IHrScheduleService;
import com.ruoyi.system.service.hr.IHrShiftService;

@Controller
@RequestMapping("/hr/employeeSetting")
public class HrEmployeeSettingController extends BaseController
{
    private final String prefix = "hr/employeeSetting";

    @Autowired
    private IHrEmployeeSettingService employeeSettingService;

    @Autowired
    private IHrShiftService shiftService;

    @Autowired
    private IHrScheduleService scheduleService;

    @Autowired
    private ISysPostService postService;

    @RequiresPermissions("hr:employeeSetting:view")
    @GetMapping()
    public String employeeSetting(ModelMap mmap)
    {
        HrShift shiftQuery = new HrShift();
        shiftQuery.setStatus("0");
        shiftQuery.setIsRestShift("0");
        mmap.put("shifts", shiftService.selectHrShiftList(shiftQuery));
        mmap.put("posts", postService.selectPostAll());
        return prefix + "/employeeSetting";
    }

    @RequiresPermissions("hr:employeeSetting:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(HrEmployeeSetting query)
    {
        startPage();
        return getDataTable(employeeSettingService.selectHrEmployeeSettingList(query));
    }

    @RequiresPermissions("hr:employeeSetting:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(HrEmployeeSetting query)
    {
        ExcelUtil<HrEmployeeSetting> util = new ExcelUtil<>(HrEmployeeSetting.class);
        return util.exportExcel(employeeSettingService.selectHrEmployeeSettingList(query), "员工设置");
    }

    @RequiresPermissions("hr:employeeSetting:edit")
    @GetMapping("/edit/{userId}")
    public String edit(@PathVariable("userId") Long userId, ModelMap mmap)
    {
        HrEmployeeSetting setting = employeeSettingService.selectHrEmployeeSettingByUserId(userId);
        mmap.put("employeeSetting", setting);
        HrShift shiftQuery = new HrShift();
        shiftQuery.setStatus("0");
        shiftQuery.setIsRestShift("0");
        mmap.put("shifts", shiftService.selectHrShiftList(shiftQuery));
        return prefix + "/edit";
    }

    @RequiresPermissions("hr:employeeSetting:edit")
    @Log(title = "员工设置", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(HrEmployeeSetting setting)
    {
        int rows = employeeSettingService.saveHrEmployeeSetting(setting, getLoginName());
        scheduleService.syncEmployeeFutureWindow(setting.getUserId(), 7, getLoginName());
        return rows > 0 ? AjaxResult.success("保存成功，已同步该员工未来7天排班与考勤明细") : AjaxResult.error("保存失败");
    }

    @RequiresPermissions("hr:employeeSetting:edit")
    @Log(title = "员工设置", businessType = BusinessType.UPDATE)
    @PostMapping("/batchEdit")
    @ResponseBody
    public AjaxResult batchEdit(@RequestParam("userIds") String userIds, HrEmployeeSetting setting)
    {
        Long[] ids = Convert.toLongArray(userIds);
        int rows = employeeSettingService.batchSaveHrEmployeeSetting(ids, setting, getLoginName());
        for (Long userId : ids)
        {
            if (userId != null)
            {
                scheduleService.syncEmployeeFutureWindow(userId, 7, getLoginName());
            }
        }
        return AjaxResult.success("批量保存成功，共处理 " + rows + " 条员工设置，并已同步未来7天排班与考勤明细");
    }
}
