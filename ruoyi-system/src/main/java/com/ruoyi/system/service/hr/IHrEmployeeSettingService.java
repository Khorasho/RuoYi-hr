package com.ruoyi.system.service.hr;

import java.util.Date;
import java.util.List;
import com.ruoyi.system.domain.hr.HrEmployeeSetting;

public interface IHrEmployeeSettingService
{
    List<HrEmployeeSetting> selectHrEmployeeSettingList(HrEmployeeSetting query);

    HrEmployeeSetting selectHrEmployeeSettingByUserId(Long userId);

    int saveHrEmployeeSetting(HrEmployeeSetting setting, String operator);

    int batchSaveHrEmployeeSetting(Long[] userIds, HrEmployeeSetting setting, String operator);

    int countConfiguredAttendanceUsers();

    int saveOnboardingInfo(Long userId, Date entryDate, String operator);

    int saveDepartureInfo(Long userId, Date leaveDate, String remark, String operator);
}
