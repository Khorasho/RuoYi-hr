package com.ruoyi.system.service.hr;

import com.ruoyi.system.domain.hr.HrAttendanceRule;

public interface IHrAttendanceRuleService
{
    HrAttendanceRule selectActiveRule();
    int updateHrAttendanceRule(HrAttendanceRule rule);
}
