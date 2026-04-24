package com.ruoyi.system.service.hr;

import java.util.List;
import com.ruoyi.system.domain.hr.HrEmployee;

public interface IHrEmployeeService
{
    List<HrEmployee> selectHrEmployeeList(HrEmployee employee);
    List<HrEmployee> selectHrEmployeeByIds(Long[] ids);
    HrEmployee selectHrEmployeeById(Long hrEmployeeId);
    int insertHrEmployee(HrEmployee employee);
    int updateHrEmployee(HrEmployee employee);
    int batchUpdateDefaultShift(Long shiftId, Long[] employeeIds, String updateBy);
    int clearDefaultShiftByIds(Long shiftId, Long[] employeeIds, String updateBy);
    int deleteHrEmployeeByIds(String ids);
}
