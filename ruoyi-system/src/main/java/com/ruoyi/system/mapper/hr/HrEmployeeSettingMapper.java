package com.ruoyi.system.mapper.hr;

import java.util.List;
import com.ruoyi.system.domain.hr.HrEmployeeSetting;

public interface HrEmployeeSettingMapper
{
    List<HrEmployeeSetting> selectHrEmployeeSettingList(HrEmployeeSetting query);

    HrEmployeeSetting selectHrEmployeeSettingByUserId(Long userId);

    int countHrEmployeeSettingByUserId(Long userId);

    int insertHrEmployeeSetting(HrEmployeeSetting setting);

    int updateHrEmployeeSetting(HrEmployeeSetting setting);
}
