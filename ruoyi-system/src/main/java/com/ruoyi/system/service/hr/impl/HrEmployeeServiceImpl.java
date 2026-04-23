package com.ruoyi.system.service.hr.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.system.domain.hr.HrEmployee;
import com.ruoyi.system.mapper.hr.HrEmployeeMapper;
import com.ruoyi.system.service.hr.IHrEmployeeService;

@Service
public class HrEmployeeServiceImpl implements IHrEmployeeService
{
    @Autowired
    private HrEmployeeMapper employeeMapper;

    @Override
    public List<HrEmployee> selectHrEmployeeList(HrEmployee employee)
    {
        return employeeMapper.selectHrEmployeeList(employee);
    }

    @Override
    public HrEmployee selectHrEmployeeById(Long hrEmployeeId)
    {
        return employeeMapper.selectHrEmployeeById(hrEmployeeId);
    }

    @Override
    public int insertHrEmployee(HrEmployee employee)
    {
        return employeeMapper.insertHrEmployee(employee);
    }

    @Override
    public int updateHrEmployee(HrEmployee employee)
    {
        return employeeMapper.updateHrEmployee(employee);
    }

    @Override
    public int deleteHrEmployeeByIds(String ids)
    {
        return employeeMapper.deleteHrEmployeeByIds(Convert.toLongArray(ids));
    }
}
