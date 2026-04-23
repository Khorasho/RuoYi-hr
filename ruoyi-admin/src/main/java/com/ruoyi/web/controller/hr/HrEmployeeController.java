package com.ruoyi.web.controller.hr;

import java.util.List;
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
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrEmployee;
import com.ruoyi.system.service.hr.IHrEmployeeService;

@Controller
@RequestMapping("/hr/employee")
public class HrEmployeeController extends BaseController
{
    private final String prefix = "hr/employee";

    @Autowired
    private IHrEmployeeService employeeService;

    @RequiresPermissions("hr:employee:view")
    @GetMapping()
    public String employee()
    {
        return prefix + "/employee";
    }

    @RequiresPermissions("hr:employee:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(HrEmployee query)
    {
        startPage();
        List<HrEmployee> list = employeeService.selectHrEmployeeList(query);
        return getDataTable(list);
    }

    @RequiresPermissions("hr:employee:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(HrEmployee query)
    {
        List<HrEmployee> list = employeeService.selectHrEmployeeList(query);
        ExcelUtil<HrEmployee> util = new ExcelUtil<>(HrEmployee.class);
        return util.exportExcel(list, "HR员工数据");
    }

    @GetMapping("/add")
    public String add()
    {
        return prefix + "/add";
    }

    @RequiresPermissions("hr:employee:add")
    @Log(title = "HR员工", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(HrEmployee employee)
    {
        employee.setCreateBy(getLoginName());
        return toAjax(employeeService.insertHrEmployee(employee));
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap)
    {
        mmap.put("employee", employeeService.selectHrEmployeeById(id));
        return prefix + "/edit";
    }

    @RequiresPermissions("hr:employee:edit")
    @Log(title = "HR员工", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(HrEmployee employee)
    {
        employee.setUpdateBy(getLoginName());
        return toAjax(employeeService.updateHrEmployee(employee));
    }

    @RequiresPermissions("hr:employee:remove")
    @Log(title = "HR员工", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids)
    {
        return toAjax(employeeService.deleteHrEmployeeByIds(ids));
    }
}
