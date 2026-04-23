package com.ruoyi.web.controller.hr;

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
import com.ruoyi.system.service.hr.IHrAttendanceRuleService;

@Controller
@RequestMapping("/hr/rule")
public class HrAttendanceRuleController extends BaseController
{
    private final String prefix = "hr/rule";

    @Autowired
    private IHrAttendanceRuleService ruleService;

    @RequiresPermissions("hr:attendance:view")
    @GetMapping()
    public String rule(ModelMap mmap)
    {
        mmap.put("rule", ruleService.selectActiveRule());
        return prefix + "/rule";
    }

    @RequiresPermissions("hr:attendance:edit")
    @Log(title = "HR考勤规则", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult edit(HrAttendanceRule rule)
    {
        rule.setUpdateBy(getLoginName());
        return toAjax(ruleService.updateHrAttendanceRule(rule));
    }
}
