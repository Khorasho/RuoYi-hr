package com.ruoyi.system.mapper.hr;

import com.ruoyi.system.domain.hr.HrAttendanceRule;

public interface HrAttendanceRuleMapper
{
    HrAttendanceRule selectActiveRule();
    int updateHrAttendanceRule(HrAttendanceRule rule);
}
