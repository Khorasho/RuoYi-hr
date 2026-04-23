package com.ruoyi.system.service.hr;

import java.util.List;
import com.ruoyi.system.domain.hr.HrEmployee;

public interface IHrEmployeeService
{
    List<HrEmployee> selectHrEmployeeList(HrEmployee employee);
    HrEmployee selectHrEmployeeById(Long hrEmployeeId);
    int insertHrEmployee(HrEmployee employee);
    int updateHrEmployee(HrEmployee employee);
    int deleteHrEmployeeByIds(String ids);
}
