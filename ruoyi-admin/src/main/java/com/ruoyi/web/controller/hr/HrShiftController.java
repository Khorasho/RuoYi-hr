package com.ruoyi.web.controller.hr;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.shiro.authz.annotation.Logical;
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
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.SysPost;
import com.ruoyi.system.domain.hr.HrSchedule;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.ISysPostService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.system.service.hr.IHrScheduleService;
import com.ruoyi.system.service.hr.IHrShiftService;

@Controller
@RequestMapping("/hr/shift")
public class HrShiftController extends BaseController
{
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    private final String prefix = "hr/shift";

    @Autowired
    private IHrShiftService shiftService;

    @Autowired
    private ISysPostService postService;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private IHrScheduleService scheduleService;

    @Autowired
    private SysUserMapper userMapper;

    @RequiresPermissions("hr:shift:view")
    @GetMapping()
    public String shift()
    {
        return prefix + "/shift";
    }

    @RequiresPermissions("hr:shift:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(HrShift query)
    {
        startPage();
        return getDataTable(shiftService.selectHrShiftList(query));
    }

    @RequiresPermissions("hr:shift:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(HrShift query)
    {
        ExcelUtil<HrShift> util = new ExcelUtil<>(HrShift.class);
        return util.exportExcel(shiftService.selectHrShiftList(query), "班次数据");
    }

    @GetMapping("/add")
    public String add()
    {
        return prefix + "/add";
    }

    @RequiresPermissions(value = { "hr:shift:add", "hr:shift:edit" }, logical = Logical.OR)
    @PostMapping("/generateCode")
    @ResponseBody
    public AjaxResult generateCode(@RequestParam("shiftName") String shiftName,
        @RequestParam(value = "shiftId", required = false) Long shiftId)
    {
        if (StringUtils.isEmpty(shiftName))
        {
            return AjaxResult.error("班次名称不能为空");
        }
        String shiftCode = shiftService.generateShiftCode(shiftName, shiftId);
        return AjaxResult.success().put("shiftCode", shiftCode);
    }

    @RequiresPermissions("hr:shift:add")
    @Log(title = "HR班次", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(HrShift shift,
        @RequestParam(value = "segmentName", required = false) String[] segmentName,
        @RequestParam(value = "periodStart", required = false) String[] periodStart,
        @RequestParam(value = "periodEnd", required = false) String[] periodEnd,
        @RequestParam(value = "validBegin", required = false) String[] validBegin,
        @RequestParam(value = "validEnd", required = false) String[] validEnd,
        @RequestParam(value = "needInPunch", required = false) String[] needInPunch,
        @RequestParam(value = "needOutPunch", required = false) String[] needOutPunch,
        @RequestParam(value = "crossDay", required = false) String[] crossDay,
        @RequestParam(value = "segmentRemark", required = false) String[] segmentRemark,
        @RequestParam(value = "workdayMask", required = false) String workdayMask)
    {
        if (StringUtils.isEmpty(shift.getPostType()))
        {
            return AjaxResult.error("请选择岗位");
        }
        shift.setWorkdayMask(workdayMask);
        shift.setCreateBy(getLoginName());
        return toAjax(shiftService.insertHrShift(shift, buildPeriods(segmentName, periodStart, periodEnd, validBegin, validEnd,
            needInPunch, needOutPunch, crossDay, segmentRemark)));
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap)
    {
        HrShift shift = shiftService.selectHrShiftById(id);
        if (shift != null)
        {
            shift.setWorkdayMask(normalizeWorkdayMask(shift.getWorkdayMask()));
        }
        mmap.put("shift", shift);
        mmap.put("workdayMask", shift != null ? shift.getWorkdayMask() : "1111100");
        mmap.put("periods", shiftService.selectPeriodsByShiftId(id));
        return prefix + "/edit";
    }

    @RequiresPermissions("hr:shift:edit")
    @GetMapping("/selectEmployee/{shiftId}")
    public String selectEmployee(@PathVariable("shiftId") Long shiftId, ModelMap mmap)
    {
        mmap.put("shiftId", shiftId);
        return prefix + "/selectEmployee";
    }

    @RequiresPermissions("hr:shift:view")
    @PostMapping("/scheduleList/{shiftId}")
    @ResponseBody
    public TableDataInfo scheduleList(@PathVariable("shiftId") Long shiftId)
    {
        startPage();
        return getDataTable(scheduleService.selectByShiftId(shiftId));
    }

    @RequiresPermissions("hr:shift:edit")
    @PostMapping("/selectEmployee/list")
    @ResponseBody
    public TableDataInfo selectEmployeeList(SysUser query)
    {
        if (StringUtils.isEmpty(query.getStatus()))
        {
            query.setStatus("0");
        }
        startPage();
        return getDataTable(userMapper.selectUserList(query));
    }

    @RequiresPermissions("hr:shift:edit")
    @PostMapping("/assignEmployees")
    @ResponseBody
    public AjaxResult assignEmployees(@RequestParam("shiftId") Long shiftId,
        @RequestParam("employeeIds") String employeeIds,
        @RequestParam(defaultValue = "false") boolean overwrite)
    {
        if (shiftId == null)
        {
            return AjaxResult.error("参数错误：缺少班次ID");
        }
        HrShift shift = shiftService.selectHrShiftById(shiftId);
        if (shift == null)
        {
            return AjaxResult.error("班次不存在或已删除");
        }

        Long[] ids = Convert.toLongArray(employeeIds);
        if (ids == null || ids.length == 0)
        {
            return AjaxResult.error("请先选择员工");
        }

        Map<Long, SysUser> userMap = new HashMap<>();
        for (Long userId : ids)
        {
            SysUser user = userService.selectUserById(userId);
            if (user != null)
            {
                userMap.put(userId, user);
            }
        }

        LocalDate workDate = LocalDate.now();
        Date scheduleDate = Date.from(workDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        List<String> conflictNames = new ArrayList<>();
        List<String> conflictIds = new ArrayList<>();
        Set<Long> skipIds = new HashSet<>();
        for (Long userId : ids)
        {
            HrSchedule existing = scheduleService.selectByUserAndDate(userId, workDate);
            if (existing == null)
            {
                continue;
            }
            if (shiftId.equals(existing.getShiftId()))
            {
                skipIds.add(userId);
                continue;
            }
            if (!overwrite && existing.getShiftId() != null)
            {
                SysUser user = userMap.get(userId);
                conflictNames.add(user != null ? user.getUserName() : String.valueOf(userId));
                conflictIds.add(String.valueOf(userId));
            }
        }

        if (!conflictNames.isEmpty())
        {
            return AjaxResult.error("以下员工当天已分配到其他班次：" + String.join("、", conflictNames) + "。是否覆盖？")
                .put("conflict", true)
                .put("conflictEmployeeIds", String.join(",", conflictIds));
        }

        int rows = 0;
        for (Long userId : ids)
        {
            SysUser user = userMap.get(userId);
            if (user == null)
            {
                continue;
            }
            if (!overwrite && skipIds.contains(userId))
            {
                continue;
            }
            HrSchedule schedule = new HrSchedule();
            schedule.setUserId(userId);
            schedule.setDeptId(user.getDeptId());
            schedule.setWorkDate(scheduleDate);
            schedule.setShiftId(shiftId);
            schedule.setRestType("");
            schedule.setScheduleRemark("班次管理手动分配");
            schedule.setCreateBy(getLoginName());
            rows += scheduleService.insertHrSchedule(schedule, overwrite);
        }

        String msg = "已添加 " + rows + " 名员工到当前班次";
        if (!skipIds.isEmpty())
        {
            msg += "，已跳过 " + skipIds.size() + " 名已在当前班次中的员工";
        }
        return AjaxResult.success(msg);
    }

    @RequiresPermissions("hr:shift:edit")
    @PostMapping("/unbindEmployee")
    @ResponseBody
    public AjaxResult unbindEmployee(@RequestParam("shiftId") Long shiftId, @RequestParam("userId") Long userId)
    {
        if (shiftId == null || userId == null)
        {
            return AjaxResult.error("参数错误");
        }
        int rows = scheduleService.deleteByShiftAndUser(shiftId, userId);
        return rows > 0 ? AjaxResult.success("已移出班次") : AjaxResult.error("移除失败，员工可能已不在当前班次");
    }

    @RequiresPermissions("hr:shift:edit")
    @Log(title = "HR班次", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(HrShift shift,
        @RequestParam(value = "segmentName", required = false) String[] segmentName,
        @RequestParam(value = "periodStart", required = false) String[] periodStart,
        @RequestParam(value = "periodEnd", required = false) String[] periodEnd,
        @RequestParam(value = "validBegin", required = false) String[] validBegin,
        @RequestParam(value = "validEnd", required = false) String[] validEnd,
        @RequestParam(value = "needInPunch", required = false) String[] needInPunch,
        @RequestParam(value = "needOutPunch", required = false) String[] needOutPunch,
        @RequestParam(value = "crossDay", required = false) String[] crossDay,
        @RequestParam(value = "segmentRemark", required = false) String[] segmentRemark,
        @RequestParam(value = "workdayMask", required = false) String workdayMask)
    {
        if (shift.getShiftId() == null)
        {
            return AjaxResult.error("参数错误：缺少班次ID");
        }
        if (StringUtils.isEmpty(shift.getPostType()))
        {
            return AjaxResult.error("请选择岗位");
        }
        shift.setWorkdayMask(workdayMask);
        shift.setUpdateBy(getLoginName());
        int rows = shiftService.updateHrShift(shift, buildPeriods(segmentName, periodStart, periodEnd, validBegin, validEnd,
            needInPunch, needOutPunch, crossDay, segmentRemark));
        if (rows > 0)
        {
            scheduleService.syncFutureSchedule(7, getLoginName());
            return AjaxResult.success("班次已更新，系统已同步未来7天排班与考勤明细");
        }
        return AjaxResult.error("修改失败");
    }

    @RequiresPermissions("hr:shift:remove")
    @Log(title = "HR班次", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(@RequestParam("ids") String ids)
    {
        return toAjax(shiftService.deleteHrShiftByIds(ids));
    }

    @RequiresPermissions(value = { "hr:shift:list", "hr:shift:add", "hr:shift:edit" }, logical = Logical.OR)
    @GetMapping("/selectPostTree/{postId}")
    public String selectPostTree(@PathVariable("postId") Long postId, ModelMap mmap)
    {
        mmap.put("treeId", postId);
        mmap.put("treeName", "");
        return prefix + "/postTree";
    }

    @RequiresPermissions(value = { "hr:shift:list", "hr:shift:add", "hr:shift:edit" }, logical = Logical.OR)
    @GetMapping("/postTreeData")
    @ResponseBody
    public List<Ztree> postTreeData()
    {
        List<Ztree> ztrees = new ArrayList<>();
        List<SysPost> posts = postService.selectPostAll();
        for (SysPost post : posts)
        {
            if (!"0".equals(post.getStatus()))
            {
                continue;
            }
            Ztree ztree = new Ztree();
            ztree.setId(post.getPostId());
            ztree.setpId(0L);
            ztree.setName(post.getPostName());
            ztree.setTitle(post.getPostName());
            ztrees.add(ztree);
        }
        return ztrees;
    }

    private List<HrShiftPeriod> buildPeriods(String[] segmentNames, String[] startArray, String[] endArray,
        String[] validBeginArray, String[] validEndArray, String[] needInPunchArray, String[] needOutPunchArray,
        String[] crossDayArray, String[] remarkArray)
    {
        List<HrShiftPeriod> list = new ArrayList<>();
        if (startArray == null || endArray == null)
        {
            return list;
        }
        int len = Math.min(startArray.length, endArray.length);
        for (int i = 0; i < len; i++)
        {
            if (StringUtils.isEmpty(startArray[i]) || StringUtils.isEmpty(endArray[i]))
            {
                continue;
            }
            HrShiftPeriod period = new HrShiftPeriod();
            period.setPeriodNo(i + 1);
            period.setSegmentName(getArrayValue(segmentNames, i, "第" + (i + 1) + "段"));
            period.setStartTime(parseTime(startArray[i]));
            period.setEndTime(parseTime(endArray[i]));
            period.setValidBeginTime(parseTime(getArrayValue(validBeginArray, i, startArray[i])));
            period.setValidEndTime(parseTime(getArrayValue(validEndArray, i, endArray[i])));
            period.setNeedInPunch(getArrayValue(needInPunchArray, i, "1"));
            period.setNeedOutPunch(getArrayValue(needOutPunchArray, i, "1"));
            period.setCrossDay(getArrayValue(crossDayArray, i, "0"));
            period.setSegmentRemark(getArrayValue(remarkArray, i, ""));
            list.add(period);
        }
        return list;
    }

    private String getArrayValue(String[] array, int index, String defaultValue)
    {
        if (array == null || index >= array.length)
        {
            return defaultValue;
        }
        return StringUtils.isEmpty(array[index]) ? defaultValue : array[index];
    }

    private LocalTime parseTime(String value)
    {
        if (StringUtils.isEmpty(value))
        {
            return null;
        }
        String text = value.trim();
        if (!text.matches("^([01]\\d|2[0-3]):([0-5]\\d)$"))
        {
            throw new ServiceException("时间格式必须为 HH:mm，例如 08:30");
        }
        try
        {
            return LocalTime.parse(text);
        }
        catch (DateTimeParseException ex)
        {
            try
            {
                return LocalTime.parse(text, TIME_FORMATTER);
            }
            catch (DateTimeParseException ignored)
            {
                throw new ServiceException("时间格式必须为 HH:mm，例如 08:30");
            }
        }
    }

    private String normalizeWorkdayMask(String mask)
    {
        if (mask == null)
        {
            return "1111100";
        }
        String cleaned = mask.replaceAll("[^01]", "");
        return cleaned.length() == 7 ? cleaned : "1111100";
    }
}
