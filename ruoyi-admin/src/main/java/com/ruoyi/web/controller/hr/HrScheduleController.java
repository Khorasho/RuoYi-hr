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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.Ztree;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.ISysDeptService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.system.service.hr.IHrScheduleService;
import com.ruoyi.system.service.hr.IHrShiftService;

@Controller
@RequestMapping("/hr/schedule")
public class HrScheduleController extends BaseController
{
    private final String prefix = "hr/schedule";

    @Autowired
    private IHrScheduleService scheduleService;
    
    @Autowired
    private IHrShiftService shiftService;
    
    @Autowired
    private ISysDeptService deptService;
    
    @Autowired
    private ISysUserService userService;

    @Autowired
    private SysUserMapper userMapper;

    @RequiresPermissions("hr:schedule:view")
    @GetMapping()
    public String schedule()
    {
        return prefix + "/schedule";
    }

    @RequiresPermissions("hr:schedule:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(HrSchedule query)
    {
        startPage();
        List<HrSchedule> list = scheduleService.selectHrScheduleList(query);
        return getDataTable(list);
    }

    @RequiresPermissions("hr:schedule:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(HrSchedule query)
    {
        ExcelUtil<HrSchedule> util = new ExcelUtil<>(HrSchedule.class);
        return util.exportExcel(scheduleService.selectHrScheduleList(query), "排班数据");
    }

    @GetMapping("/add")
    public String add(ModelMap mmap)
    {
        mmap.put("shifts", shiftService.selectHrShiftList(new HrShift()));
        return prefix + "/add";
    }

    @RequiresPermissions("hr:schedule:add")
    @Log(title = "HR排班", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(HrSchedule schedule, @RequestParam(defaultValue = "false") boolean overwrite)
    {
        if (schedule.getUserId() == null)
        {
            return error("请选择员工");
        }
        if (schedule.getDeptId() == null)
        {
            return error("请选择部门");
        }
        if (schedule.getWorkDate() == null)
        {
            return error("请选择排班日期");
        }
        schedule.setCreateBy(getLoginName());
        return toAjax(scheduleService.insertHrSchedule(schedule, overwrite));
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap)
    {
        mmap.put("schedule", scheduleService.selectHrScheduleById(id));
        mmap.put("shifts", shiftService.selectHrShiftList(new HrShift()));
        return prefix + "/edit";
    }

    @RequiresPermissions("hr:schedule:view")
    @GetMapping("/selectDeptTree/{deptId}")
    public String selectDeptTree(@PathVariable("deptId") Long deptId, ModelMap mmap)
    {
        mmap.put("dept", deptService.selectDeptById(deptId));
        return prefix + "/deptTree";
    }

    @RequiresPermissions("hr:schedule:view")
    @GetMapping("/deptTreeData")
    @ResponseBody
    public List<Ztree> deptTreeData()
    {
        return deptService.selectDeptTree(new SysDept());
    }

    @RequiresPermissions("hr:schedule:view")
    @GetMapping("/selectUser")
    public String selectUser(@RequestParam(value = "deptId", required = false) Long deptId, ModelMap mmap)
    {
        mmap.put("deptId", deptId);
        return prefix + "/selectUser";
    }

    @RequiresPermissions("hr:schedule:view")
    @PostMapping("/userList")
    @ResponseBody
    public TableDataInfo userList(SysUser user)
    {
        if (user.getStatus() == null || user.getStatus().isEmpty())
        {
            user.setStatus("0");
        }
        startPage();
        List<SysUser> list = userMapper.selectUserList(user);
        return getDataTable(list);
    }

    @RequiresPermissions("hr:schedule:edit")
    @Log(title = "HR排班", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(HrSchedule schedule)
    {
        if (schedule.getScheduleId() == null)
        {
            return error("参数错误：缺少排班ID");
        }
        if (schedule.getUserId() == null)
        {
            return error("请选择员工");
        }
        if (schedule.getDeptId() == null)
        {
            return error("请选择部门");
        }
        if (schedule.getWorkDate() == null)
        {
            return error("请选择排班日期");
        }
        schedule.setUpdateBy(getLoginName());
        return toAjax(scheduleService.updateHrSchedule(schedule));
    }

    @RequiresPermissions("hr:schedule:remove")
    @Log(title = "HR排班", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(@RequestParam("ids") String ids)
    {
        return toAjax(scheduleService.deleteHrScheduleByIds(ids));
    }
    
    @RequiresPermissions("hr:schedule:add")
    @Log(title = "HR排班", businessType = BusinessType.OTHER)
    @PostMapping("/generateMonthly")
    @ResponseBody
    public AjaxResult generateMonthly(@RequestParam String month,
                                      @RequestParam(required = false) Long deptId,
                                      @RequestParam(required = false) Long userId,
                                      @RequestParam(defaultValue = "false") boolean overwrite)
    {
        if (month == null || !month.matches("\\d{4}-\\d{2}"))
        {
            return error("月份格式错误，应为yyyy-MM");
        }
        int rows = scheduleService.generateMonthlySchedule(month, deptId, userId, overwrite, getLoginName());
        return AjaxResult.success("月排班生成完成，共生成 " + rows + " 条记录");
    }
}
