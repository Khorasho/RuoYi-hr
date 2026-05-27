INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR考勤状态', 'hr_attendance_status', '0', 'admin', sysdate(), 'HR考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_attendance_status');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR异常类型', 'hr_exception_type', '0', 'admin', sysdate(), 'HR异常类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_exception_type');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR休息类型', 'hr_rest_type', '0', 'admin', sysdate(), 'HR休息类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_rest_type');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR生成来源', 'hr_generate_source', '0', 'admin', sysdate(), 'HR生成来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_generate_source');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR打卡类型', 'hr_punch_type', '0', 'admin', sysdate(), 'HR打卡类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_punch_type');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR打卡来源', 'hr_attendance_source', '0', 'admin', sysdate(), 'HR打卡来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_attendance_source');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR打卡记录状态', 'hr_record_status', '0', 'admin', sysdate(), 'HR打卡记录状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_record_status');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR是否', 'hr_yes_no', '0', 'admin', sysdate(), 'HR是否'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_yes_no');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR员工配置状态', 'hr_employee_config_status', '0', 'admin', sysdate(), 'HR员工配置状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_employee_config_status');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR员工在职状态', 'hr_employee_work_status', '0', 'admin', sysdate(), 'HR员工在职状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_employee_work_status');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR同步触发方式', 'hr_sync_trigger_type', '0', 'admin', sysdate(), 'HR同步触发方式'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_sync_trigger_type');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR同步状态', 'hr_sync_status', '0', 'admin', sysdate(), 'HR同步状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_sync_status');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR多次打卡策略', 'hr_multi_punch_strategy', '0', 'admin', sysdate(), 'HR多次打卡策略'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_multi_punch_strategy');

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'HR排班覆盖方式', 'hr_schedule_write_mode', '0', 'admin', sysdate(), 'HR排班覆盖方式'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'hr_schedule_write_mode');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '正常', 'NORMAL', 'hr_attendance_status', '', 'success', 'Y', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='NORMAL');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '休息', 'REST', 'hr_attendance_status', '', 'info', 'N', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='REST');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '待打卡', 'PENDING_CLOCK', 'hr_attendance_status', '', 'warning', 'N', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='PENDING_CLOCK');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 4, '缺卡', 'MISS_CARD', 'hr_attendance_status', '', 'danger', 'N', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='MISS_CARD');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 5, '迟到', 'LATE', 'hr_attendance_status', '', 'warning', 'N', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='LATE');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 6, '早退', 'EARLY', 'hr_attendance_status', '', 'warning', 'N', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='EARLY');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 7, '迟到早退', 'LATE_EARLY', 'hr_attendance_status', '', 'danger', 'N', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='LATE_EARLY');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 8, '旷工', 'ABSENT', 'hr_attendance_status', '', 'danger', 'N', '0', 'admin', sysdate(), '考勤状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_status' AND dict_value='ABSENT');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '迟到', 'LATE', 'hr_exception_type', '', 'warning', 'N', '0', 'admin', sysdate(), '异常类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_exception_type' AND dict_value='LATE');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '早退', 'EARLY', 'hr_exception_type', '', 'warning', 'N', '0', 'admin', sysdate(), '异常类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_exception_type' AND dict_value='EARLY');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '缺卡', 'MISS_CARD', 'hr_exception_type', '', 'danger', 'N', '0', 'admin', sysdate(), '异常类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_exception_type' AND dict_value='MISS_CARD');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 4, '旷工', 'ABSENT', 'hr_exception_type', '', 'danger', 'N', '0', 'admin', sysdate(), '异常类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_exception_type' AND dict_value='ABSENT');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 0, '正常出勤', 'WORK', 'hr_rest_type', '', 'primary', 'N', '0', 'admin', sysdate(), '休息类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_rest_type' AND dict_value='WORK');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '休息', 'REST', 'hr_rest_type', '', 'info', 'Y', '0', 'admin', sysdate(), '休息类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_rest_type' AND dict_value='REST');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '半天休', 'HALF_REST', 'hr_rest_type', '', 'warning', 'N', '0', 'admin', sysdate(), '休息类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_rest_type' AND dict_value='HALF_REST');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '手工新增', 'MANUAL_ADD', 'hr_generate_source', '', 'primary', 'N', '0', 'admin', sysdate(), '生成来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_generate_source' AND dict_value='MANUAL_ADD');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '手工修改', 'MANUAL_EDIT', 'hr_generate_source', '', 'warning', 'N', '0', 'admin', sysdate(), '生成来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_generate_source' AND dict_value='MANUAL_EDIT');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '批量生成', 'BATCH_GEN', 'hr_generate_source', '', 'success', 'N', '0', 'admin', sysdate(), '生成来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_generate_source' AND dict_value='BATCH_GEN');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 4, '定时生成', 'AUTO_GEN', 'hr_generate_source', '', 'info', 'N', '0', 'admin', sysdate(), '生成来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_generate_source' AND dict_value='AUTO_GEN');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '上班卡', 'IN', 'hr_punch_type', '', 'primary', 'N', '0', 'admin', sysdate(), '打卡类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_punch_type' AND dict_value='IN');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '下班卡', 'OUT', 'hr_punch_type', '', 'success', 'N', '0', 'admin', sysdate(), '打卡类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_punch_type' AND dict_value='OUT');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '自动判定', 'AUTO', 'hr_punch_type', '', 'warning', 'N', '0', 'admin', sysdate(), '打卡类型'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_punch_type' AND dict_value='AUTO');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '考勤机', 'DEVICE', 'hr_attendance_source', '', 'primary', 'N', '0', 'admin', sysdate(), '打卡来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_source' AND dict_value='DEVICE');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '考勤机数据库', 'DEVICE_DB', 'hr_attendance_source', '', 'info', 'N', '0', 'admin', sysdate(), '打卡来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_source' AND dict_value='DEVICE_DB');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '演示数据', 'DEMO', 'hr_attendance_source', '', 'warning', 'N', '0', 'admin', sysdate(), '打卡来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_source' AND dict_value='DEMO');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 4, '手工补录', 'MANUAL', 'hr_attendance_source', '', 'danger', 'N', '0', 'admin', sysdate(), '打卡来源'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_attendance_source' AND dict_value='MANUAL');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '有效', 'VALID', 'hr_record_status', '', 'success', 'Y', '0', 'admin', sysdate(), '记录状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_record_status' AND dict_value='VALID');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '作废', 'VOID', 'hr_record_status', '', 'danger', 'N', '0', 'admin', sysdate(), '记录状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_record_status' AND dict_value='VOID');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '是', '1', 'hr_yes_no', '', 'primary', 'Y', '0', 'admin', sysdate(), 'HR是否'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_yes_no' AND dict_value='1');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '否', '0', 'hr_yes_no', '', 'danger', 'N', '0', 'admin', sysdate(), 'HR是否'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_yes_no' AND dict_value='0');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '已配置', 'CONFIGURED', 'hr_employee_config_status', '', 'success', 'Y', '0', 'admin', sysdate(), '员工配置状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_employee_config_status' AND dict_value='CONFIGURED');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '未配置', 'UNCONFIGURED', 'hr_employee_config_status', '', 'warning', 'N', '0', 'admin', sysdate(), '员工配置状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_employee_config_status' AND dict_value='UNCONFIGURED');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '在职', 'ACTIVE', 'hr_employee_work_status', '', 'success', 'Y', '0', 'admin', sysdate(), '员工在职状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_employee_work_status' AND dict_value='ACTIVE');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '已离职', 'LEFT', 'hr_employee_work_status', '', 'danger', 'N', '0', 'admin', sysdate(), '员工在职状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_employee_work_status' AND dict_value='LEFT');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '手动', 'MANUAL', 'hr_sync_trigger_type', '', 'primary', 'Y', '0', 'admin', sysdate(), '同步触发方式'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_sync_trigger_type' AND dict_value='MANUAL');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '定时', 'AUTO', 'hr_sync_trigger_type', '', 'info', 'N', '0', 'admin', sysdate(), '同步触发方式'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_sync_trigger_type' AND dict_value='AUTO');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '成功', 'SUCCESS', 'hr_sync_status', '', 'success', 'N', '0', 'admin', sysdate(), '同步状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_sync_status' AND dict_value='SUCCESS');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '失败', 'FAILED', 'hr_sync_status', '', 'danger', 'N', '0', 'admin', sysdate(), '同步状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_sync_status' AND dict_value='FAILED');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '执行中', 'RUNNING', 'hr_sync_status', '', 'warning', 'N', '0', 'admin', sysdate(), '同步状态'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_sync_status' AND dict_value='RUNNING');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '取最早上班 + 最晚下班', 'EARLIEST_IN_LATEST_OUT', 'hr_multi_punch_strategy', '', 'primary', 'Y', '0', 'admin', sysdate(), '多次打卡策略'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_multi_punch_strategy' AND dict_value='EARLIEST_IN_LATEST_OUT');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '仅补空白', 'ONLY_BLANK', 'hr_schedule_write_mode', '', 'info', 'N', '0', 'admin', sysdate(), '排班覆盖方式'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_schedule_write_mode' AND dict_value='ONLY_BLANK');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '覆盖系统生成', 'OVERWRITE_SYSTEM', 'hr_schedule_write_mode', '', 'warning', 'Y', '0', 'admin', sysdate(), '排班覆盖方式'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_schedule_write_mode' AND dict_value='OVERWRITE_SYSTEM');
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '全部覆盖', 'ALL', 'hr_schedule_write_mode', '', 'danger', 'N', '0', 'admin', sysdate(), '排班覆盖方式'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type='hr_schedule_write_mode' AND dict_value='ALL');
