package com.ruoyi.web.controller.hr;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
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
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysPost;
import com.ruoyi.system.domain.hr.HrShift;
import com.ruoyi.system.domain.hr.HrShiftPeriod;
import com.ruoyi.system.service.ISysPostService;
import com.ruoyi.system.service.hr.IHrShiftService;

@Controller
@RequestMapping("/hr/shift")
public class HrShiftController extends BaseController
{
    private final String prefix = "hr/shift";

    @Autowired
    private IHrShiftService shiftService;

    @Autowired
    private ISysPostService postService;

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
    public AjaxResult generateCode(String shiftName, Long shiftId)
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
                              @RequestParam(value = "periodStart", required = false) String[] periodStart,
                              @RequestParam(value = "periodEnd", required = false) String[] periodEnd)
    {
        shift.setCreateBy(getLoginName());
        return toAjax(shiftService.insertHrShift(shift, buildPeriods(periodStart, periodEnd)));
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap)
    {
        mmap.put("shift", shiftService.selectHrShiftById(id));
        mmap.put("periods", shiftService.selectPeriodsByShiftId(id));
        return prefix + "/edit";
    }

    @RequiresPermissions("hr:shift:edit")
    @Log(title = "HR班次", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(HrShift shift,
                               @RequestParam(value = "periodStart", required = false) String[] periodStart,
                               @RequestParam(value = "periodEnd", required = false) String[] periodEnd)
    {
        shift.setUpdateBy(getLoginName());
        return toAjax(shiftService.updateHrShift(shift, buildPeriods(periodStart, periodEnd)));
    }

    @RequiresPermissions("hr:shift:remove")
    @Log(title = "HR班次", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids)
    {
        return toAjax(shiftService.deleteHrShiftByIds(ids));
    }

    @RequiresPermissions(value = { "hr:shift:list", "hr:shift:add", "hr:shift:edit" }, logical = Logical.OR)
    @GetMapping("/selectPostTree/{deptId}")
    public String selectPostTree(@PathVariable("deptId") Long deptId, ModelMap mmap)
    {
        mmap.put("treeId", deptId);
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

    private List<HrShiftPeriod> buildPeriods(String[] startArray, String[] endArray)
    {
        List<HrShiftPeriod> list = new ArrayList<>();
        if (startArray == null || endArray == null)
        {
            return list;
        }
        int len = Math.min(startArray.length, endArray.length);
        for (int i = 0; i < len; i++)
        {
            if (startArray[i] == null || startArray[i].isBlank() || endArray[i] == null || endArray[i].isBlank())
            {
                continue;
            }
            HrShiftPeriod period = new HrShiftPeriod();
            period.setPeriodNo(i + 1);
            period.setStartTime(parseTime(startArray[i]));
            period.setEndTime(parseTime(endArray[i]));
            list.add(period);
        }
        return list;
    }

    private LocalTime parseTime(String val)
    {
        if (val == null || val.isBlank())
        {
            return null;
        }
        try
        {
            return LocalTime.parse(val);
        }
        catch (DateTimeParseException e)
        {
            return LocalTime.parse(val, DateTimeFormatter.ofPattern("HH:mm"));
        }
    }
}
