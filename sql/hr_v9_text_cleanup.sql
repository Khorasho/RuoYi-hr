-- HR 文本修复脚本（修复历史乱码与异常问号）
-- 执行环境：MySQL 5.7+/8.0+

-- 1) 修复 HR 字典类型名称
update sys_dict_type set dict_name='HR考勤状态', remark='HR考勤状态' where dict_type='hr_attendance_status';
update sys_dict_type set dict_name='HR异常类型', remark='HR异常类型' where dict_type='hr_exception_type';
update sys_dict_type set dict_name='HR休息类型', remark='HR休息类型' where dict_type='hr_rest_type';
update sys_dict_type set dict_name='HR生成来源', remark='HR生成来源' where dict_type='hr_generate_source';
update sys_dict_type set dict_name='HR打卡类型', remark='HR打卡类型' where dict_type='hr_punch_type';
update sys_dict_type set dict_name='HR打卡来源', remark='HR打卡来源' where dict_type='hr_attendance_source';
update sys_dict_type set dict_name='HR打卡记录状态', remark='HR打卡记录状态' where dict_type='hr_record_status';
update sys_dict_type set dict_name='HR是否', remark='HR是否' where dict_type='hr_yes_no';
update sys_dict_type set dict_name='HR员工配置状态', remark='HR员工配置状态' where dict_type='hr_employee_config_status';
update sys_dict_type set dict_name='HR员工在职状态', remark='HR员工在职状态' where dict_type='hr_employee_work_status';
update sys_dict_type set dict_name='HR同步触发方式', remark='HR同步触发方式' where dict_type='hr_sync_trigger_type';
update sys_dict_type set dict_name='HR同步状态', remark='HR同步状态' where dict_type='hr_sync_status';
update sys_dict_type set dict_name='HR多次打卡策略', remark='HR多次打卡策略' where dict_type='hr_multi_punch_strategy';
update sys_dict_type set dict_name='HR排班覆盖方式', remark='HR排班覆盖方式' where dict_type='hr_schedule_write_mode';
update sys_dict_type set dict_name='HR班次排班模式', remark='HR班次排班模式' where dict_type='hr_shift_schedule_mode';

-- 2) 修复 HR 字典项（按 type + value 精准回写）
update sys_dict_data set dict_label='正常' where dict_type='hr_attendance_status' and dict_value='NORMAL';
update sys_dict_data set dict_label='休息' where dict_type='hr_attendance_status' and dict_value='REST';
update sys_dict_data set dict_label='待打卡' where dict_type='hr_attendance_status' and dict_value='PENDING_CLOCK';
update sys_dict_data set dict_label='缺卡' where dict_type='hr_attendance_status' and dict_value='MISS_CARD';
update sys_dict_data set dict_label='迟到' where dict_type='hr_attendance_status' and dict_value='LATE';
update sys_dict_data set dict_label='早退' where dict_type='hr_attendance_status' and dict_value='EARLY';
update sys_dict_data set dict_label='迟到早退' where dict_type='hr_attendance_status' and dict_value='LATE_EARLY';
update sys_dict_data set dict_label='旷工' where dict_type='hr_attendance_status' and dict_value='ABSENT';

update sys_dict_data set dict_label='迟到' where dict_type='hr_exception_type' and dict_value='LATE';
update sys_dict_data set dict_label='早退' where dict_type='hr_exception_type' and dict_value='EARLY';
update sys_dict_data set dict_label='缺卡' where dict_type='hr_exception_type' and dict_value='MISS_CARD';
update sys_dict_data set dict_label='旷工' where dict_type='hr_exception_type' and dict_value='ABSENT';

update sys_dict_data set dict_label='正常出勤' where dict_type='hr_rest_type' and dict_value='WORK';
update sys_dict_data set dict_label='休息' where dict_type='hr_rest_type' and dict_value='REST';
update sys_dict_data set dict_label='半天休' where dict_type='hr_rest_type' and dict_value='HALF_REST';

update sys_dict_data set dict_label='手工新增' where dict_type='hr_generate_source' and dict_value='MANUAL_ADD';
update sys_dict_data set dict_label='手工修改' where dict_type='hr_generate_source' and dict_value='MANUAL_EDIT';
update sys_dict_data set dict_label='批量生成' where dict_type='hr_generate_source' and dict_value='BATCH_GEN';
update sys_dict_data set dict_label='定时生成' where dict_type='hr_generate_source' and dict_value='AUTO_GEN';

update sys_dict_data set dict_label='上班卡' where dict_type='hr_punch_type' and dict_value='IN';
update sys_dict_data set dict_label='下班卡' where dict_type='hr_punch_type' and dict_value='OUT';
update sys_dict_data set dict_label='自动判定' where dict_type='hr_punch_type' and dict_value='AUTO';

update sys_dict_data set dict_label='考勤机' where dict_type='hr_attendance_source' and dict_value='DEVICE';
update sys_dict_data set dict_label='考勤机数据库' where dict_type='hr_attendance_source' and dict_value='DEVICE_DB';
update sys_dict_data set dict_label='演示数据' where dict_type='hr_attendance_source' and dict_value='DEMO';
update sys_dict_data set dict_label='手工补录' where dict_type='hr_attendance_source' and dict_value='MANUAL';

update sys_dict_data set dict_label='有效' where dict_type='hr_record_status' and dict_value='VALID';
update sys_dict_data set dict_label='作废' where dict_type='hr_record_status' and dict_value='VOID';

update sys_dict_data set dict_label='是' where dict_type='hr_yes_no' and dict_value='1';
update sys_dict_data set dict_label='否' where dict_type='hr_yes_no' and dict_value='0';

update sys_dict_data set dict_label='已配置' where dict_type='hr_employee_config_status' and dict_value='CONFIGURED';
update sys_dict_data set dict_label='未配置' where dict_type='hr_employee_config_status' and dict_value='UNCONFIGURED';
update sys_dict_data set dict_label='在职' where dict_type='hr_employee_work_status' and dict_value='ACTIVE';
update sys_dict_data set dict_label='已离职' where dict_type='hr_employee_work_status' and dict_value='LEFT';

update sys_dict_data set dict_label='手动' where dict_type='hr_sync_trigger_type' and dict_value='MANUAL';
update sys_dict_data set dict_label='定时' where dict_type='hr_sync_trigger_type' and dict_value='AUTO';
update sys_dict_data set dict_label='成功' where dict_type='hr_sync_status' and dict_value='SUCCESS';
update sys_dict_data set dict_label='失败' where dict_type='hr_sync_status' and dict_value='FAILED';
update sys_dict_data set dict_label='执行中' where dict_type='hr_sync_status' and dict_value='RUNNING';

update sys_dict_data set dict_label='取最早上班 + 最晚下班' where dict_type='hr_multi_punch_strategy' and dict_value='EARLIEST_IN_LATEST_OUT';
update sys_dict_data set dict_label='仅补空白' where dict_type='hr_schedule_write_mode' and dict_value='ONLY_BLANK';
update sys_dict_data set dict_label='覆盖系统生成' where dict_type='hr_schedule_write_mode' and dict_value='OVERWRITE_SYSTEM';
update sys_dict_data set dict_label='全部覆盖' where dict_type='hr_schedule_write_mode' and dict_value='ALL';
update sys_dict_data set dict_label='周排班' where dict_type='hr_shift_schedule_mode' and dict_value='WEEKLY';
update sys_dict_data set dict_label='轮班制' where dict_type='hr_shift_schedule_mode' and dict_value='ROTATION';

-- 3) 修复历史班段名称乱码（兜底）
update hr_shift_period
set segment_name = concat('第', ifnull(period_no, 1), '段')
where segment_name is null
   or trim(segment_name) = ''
   or segment_name like '%???%'
   or segment_name like '%ç¬¬%'
   or segment_name like '%æ®µ%'
   or segment_name like '%Ã%'
   or segment_name like '%Â%';

-- 4) 修复员工设置备注乱码（兜底）
update hr_employee_setting
set emp_remark = '批量初始化员工设置'
where emp_remark is not null
  and (
       emp_remark like '%???%'
    or emp_remark regexp '^[?？]+$'
    or emp_remark like '%Ã%'
    or emp_remark like '%Â%'
    or emp_remark like '%ç%'
    or emp_remark like '%æ%'
    or emp_remark like '%å%'
  );

-- 5) 清理排班备注中的乱码片段
update hr_schedule
set schedule_remark = replace(replace(schedule_remark, '???', ''), '�', '')
where schedule_remark like '%???%' or schedule_remark like '%�%';

