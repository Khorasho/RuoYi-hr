package com.ruoyi.system.mapper.hr;

import java.util.List;
import com.ruoyi.system.domain.hr.HrEmployee;

public interface HrEmployeeMapper
{
    List<HrEmployee> selectHrEmployeeList(HrEmployee employee);
    List<HrEmployee> selectHrEmployeeByIds(Long[] ids);
    HrEmployee selectHrEmployeeById(Long hrEmployeeId);
    int insertHrEmployee(HrEmployee employee);
    int updateHrEmployee(HrEmployee employee);
    int batchUpdateDefaultShift(Long shiftId, String updateBy, Long[] employeeIds);
    int clearDefaultShiftByIds(Long shiftId, String updateBy, Long[] employeeIds);
    int deleteHrEmployeeByIds(Long[] ids);
}
