package com.ruoyi.system.service.hr;

import java.time.LocalDate;
import java.util.List;
import com.ruoyi.system.domain.hr.HrSchedule;

public interface IHrScheduleService
{
    List<HrSchedule> selectHrScheduleList(HrSchedule schedule);

    HrSchedule selectHrScheduleById(Long scheduleId);

    int insertHrSchedule(HrSchedule schedule, boolean overwrite);

    int updateHrSchedule(HrSchedule schedule, boolean overwrite);

    int deleteHrScheduleByIds(String ids, String operator);

    int generateMonthlySchedule(String month, Long deptId, Long userId, boolean overwrite, String operator);

    int generateMonthlyScheduleBatch(String month, List<Long> userIds, boolean overwrite, String operator);

    int updateScheduleRange(LocalDate beginDate, LocalDate endDate, Long deptId, Long userId, List<Long> userIds, String mode, String operator);

    int copyScheduleRange(LocalDate sourceBeginDate, LocalDate sourceEndDate, LocalDate targetBeginDate, LocalDate targetEndDate, Long deptId, List<Long> userIds, String mode, String operator);

    int syncFutureSchedule(int days, String operator);

    int syncEmployeeFutureWindow(Long userId, int days, String operator);

    HrSchedule selectByUserAndDate(Long userId, LocalDate workDate);

    List<HrSchedule> selectByShiftId(Long shiftId);

    int deleteByShiftAndUser(Long shiftId, Long userId);
}
