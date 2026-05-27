package com.ruoyi.web.controller.hr;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
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
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.Ztree;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.ISysDeptService;
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
        return getDataTable(scheduleService.selectHrScheduleList(query));
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
        HrShift shiftQuery = new HrShift();
        shiftQuery.setStatus("0");
        mmap.put("shifts", shiftService.selectHrShiftList(shiftQuery));
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
        SysUser user = userMapper.selectUserById(schedule.getUserId());
        if (user == null)
        {
            return error("员工不存在或已删除");
        }
        if (user.getDeptId() == null)
        {
            return error("该员工未配置所属部门");
        }
        schedule.setDeptId(user.getDeptId());
        if (schedule.getWorkDate() == null)
        {
            return error("请选择排班日期");
        }
        if (schedule.getShiftId() == null)
        {
            return error("请选择班次");
        }
        schedule.setCreateBy(getLoginName());
        return toAjax(scheduleService.insertHrSchedule(schedule, overwrite));
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap)
    {
        mmap.put("schedule", scheduleService.selectHrScheduleById(id));
        HrShift shiftQuery = new HrShift();
        shiftQuery.setStatus("0");
        mmap.put("shifts", shiftService.selectHrShiftList(shiftQuery));
        return prefix + "/edit";
    }

    @RequiresPermissions("hr:schedule:view")
    @GetMapping("/selectDeptTree/{deptId}")
    public String selectDeptTree(@PathVariable("deptId") Long deptId, ModelMap mmap)
    {
        mmap.put("dept", deptId == null || deptId <= 0 ? null : deptService.selectDeptById(deptId));
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
        return getDataTable(userMapper.selectUserList(user));
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
        SysUser user = userMapper.selectUserById(schedule.getUserId());
        if (user == null)
        {
            return error("员工不存在或已删除");
        }
        if (user.getDeptId() == null)
        {
            return error("该员工未配置所属部门");
        }
        schedule.setDeptId(user.getDeptId());
        if (schedule.getWorkDate() == null)
        {
            return error("请选择排班日期");
        }
        if (schedule.getShiftId() == null)
        {
            return error("请选择班次");
        }
        schedule.setUpdateBy(getLoginName());
        return toAjax(scheduleService.updateHrSchedule(schedule, false));
    }

    @RequiresPermissions("hr:schedule:remove")
    @Log(title = "HR排班", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(@RequestParam("ids") String ids)
    {
        return toAjax(scheduleService.deleteHrScheduleByIds(ids, getLoginName()));
    }

    @RequiresPermissions("hr:schedule:generate")
    @Log(title = "月排班生成", businessType = BusinessType.OTHER)
    @PostMapping("/generateMonthly")
    @ResponseBody
    public AjaxResult generateMonthly(@RequestParam String month,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long userId,
        @RequestParam(defaultValue = "false") boolean overwrite)
    {
        if (month == null || !month.matches("\\d{4}-\\d{2}"))
        {
            return error("月份格式错误，应为 yyyy-MM");
        }
        int rows = scheduleService.generateMonthlySchedule(month, deptId, userId, overwrite, getLoginName());
        return AjaxResult.success("月排班生成完成，共处理 " + rows + " 条记录");
    }

    @RequiresPermissions("hr:schedule:generate")
    @Log(title = "批量月排班生成", businessType = BusinessType.OTHER)
    @PostMapping("/generateMonthlyBatch")
    @ResponseBody
    public AjaxResult generateMonthlyBatch(@RequestParam String month,
        @RequestParam String userIds,
        @RequestParam(defaultValue = "false") boolean overwrite)
    {
        if (month == null || !month.matches("\\d{4}-\\d{2}"))
        {
            return error("月份格式错误，应为 yyyy-MM");
        }
        List<Long> idList = Arrays.stream(Convert.toStrArray(userIds))
            .filter(item -> item != null && !item.isEmpty())
            .map(Long::valueOf)
            .collect(Collectors.toList());
        if (idList.isEmpty())
        {
            return error("请先选择员工");
        }
        int rows = scheduleService.generateMonthlyScheduleBatch(month, idList, overwrite, getLoginName());
        return AjaxResult.success("批量月排班生成完成，共处理 " + rows + " 条记录");
    }

    @RequiresPermissions("hr:schedule:updateRange")
    @Log(title = "排班更新", businessType = BusinessType.UPDATE)
    @PostMapping("/updateRange")
    @ResponseBody
    public AjaxResult updateRange(@RequestParam String beginDate,
        @RequestParam String endDate,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long userId,
        @RequestParam(required = false) String userIds,
        @RequestParam(defaultValue = "OVERWRITE_SYSTEM") String mode)
    {
        LocalDate begin = LocalDate.parse(beginDate);
        LocalDate end = LocalDate.parse(endDate);
        List<Long> idList = null;
        if (userIds != null && !userIds.trim().isEmpty())
        {
            idList = Arrays.stream(Convert.toStrArray(userIds))
                .filter(item -> item != null && !item.isEmpty())
                .map(Long::valueOf)
                .collect(Collectors.toList());
        }
        int rows = scheduleService.updateScheduleRange(begin, end, deptId, userId, idList, mode, getLoginName());
        return AjaxResult.success("排班更新完成，共处理 " + rows + " 条记录");
    }

    @RequiresPermissions("hr:schedule:updateRange")
    @Log(title = "排班复制", businessType = BusinessType.OTHER)
    @PostMapping("/copyRange")
    @ResponseBody
    public AjaxResult copyRange(@RequestParam String sourceBeginDate,
        @RequestParam String sourceEndDate,
        @RequestParam String targetBeginDate,
        @RequestParam String targetEndDate,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) String userIds,
        @RequestParam(defaultValue = "OVERWRITE_SYSTEM") String mode)
    {
        List<Long> idList = null;
        if (userIds != null && !userIds.trim().isEmpty())
        {
            idList = Arrays.stream(Convert.toStrArray(userIds))
                .filter(item -> item != null && !item.isEmpty())
                .map(Long::valueOf)
                .collect(Collectors.toList());
        }
        int rows = scheduleService.copyScheduleRange(
            LocalDate.parse(sourceBeginDate),
            LocalDate.parse(sourceEndDate),
            LocalDate.parse(targetBeginDate),
            LocalDate.parse(targetEndDate),
            deptId,
            idList,
            mode,
            getLoginName());
        return AjaxResult.success("复制排班完成，共处理 " + rows + " 条记录");
    }

    @RequiresPermissions("hr:schedule:updateRange")
    @Log(title = "未来七天排班同步", businessType = BusinessType.OTHER)
    @PostMapping("/syncFutureSevenDays")
    @ResponseBody
    public AjaxResult syncFutureSevenDays()
    {
        int rows = scheduleService.syncFutureSchedule(7, getLoginName());
        return AjaxResult.success("未来7天排班同步完成，共处理 " + rows + " 条记录");
    }
}
