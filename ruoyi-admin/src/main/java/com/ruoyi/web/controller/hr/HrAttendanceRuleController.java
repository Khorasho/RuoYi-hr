package com.ruoyi.web.controller.hr;

import java.time.LocalDate;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.hr.HrAttendanceRule;
import com.ruoyi.system.service.hr.IHrAttendanceService;
import com.ruoyi.system.service.hr.IHrAttendanceRuleService;

@Controller
@RequestMapping("/hr/rule")
public class HrAttendanceRuleController extends BaseController
{
    private final String prefix = "hr/rule";

    @Autowired
    private IHrAttendanceRuleService ruleService;

    @Autowired
    private IHrAttendanceService attendanceService;

    @RequiresPermissions("hr:attendance:view")
    @GetMapping()
    public String rule(ModelMap mmap)
    {
        HrAttendanceRule rule = ruleService.selectActiveRule();
        if (rule == null)
        {
            rule = new HrAttendanceRule();
            rule.setRuleId(1L);
            rule.setLateMinutes(10);
            rule.setEarlyMinutes(10);
            rule.setAbsentMinutes(120);
            rule.setDayCloseMinutes(120);
            rule.setMultiPunchStrategy("EARLIEST_IN_LATEST_OUT");
        }
        mmap.put("rule", rule);
        return prefix + "/rule";
    }

    @RequiresPermissions("hr:attendance:edit")
    @Log(title = "HR考勤规则", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult edit(HrAttendanceRule rule)
    {
        rule.setUpdateBy(getLoginName());
        int rows = ruleService.updateHrAttendanceRule(rule);
        LocalDate today = LocalDate.now();
        attendanceService.generateMonthly(today.getYear() + "-" + String.format("%02d", today.getMonthValue()), getLoginName());
        return rows > 0 ? AjaxResult.success("规则已保存，并已重算当月考勤明细") : AjaxResult.error("保存失败");
    }
}
