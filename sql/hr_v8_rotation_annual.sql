set @db_name = database();

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift' and column_name = 'schedule_mode'
    ),
    'select 1',
    'alter table hr_shift add column schedule_mode varchar(16) default ''WEEKLY'' comment ''排班模式(WEEKLY周排班,ROTATION轮班)'' after workday_mask'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift' and column_name = 'rotation_work_days'
    ),
    'select 1',
    'alter table hr_shift add column rotation_work_days int default null comment ''轮班上班天数'' after schedule_mode'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift' and column_name = 'rotation_rest_days'
    ),
    'select 1',
    'alter table hr_shift add column rotation_rest_days int default null comment ''轮班休息天数'' after rotation_work_days'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_employee_setting' and column_name = 'rotation_anchor_date'
    ),
    'select 1',
    'alter table hr_employee_setting add column rotation_anchor_date date default null comment ''轮班起算日期'' after leave_date'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

update hr_shift
set schedule_mode = 'WEEKLY'
where schedule_mode is null or schedule_mode = '';

insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select 'HR排班模式', 'hr_shift_schedule_mode', '0', 'admin', sysdate(), 'HR班次排班模式'
from dual
where not exists (
    select 1 from sys_dict_type where dict_type = 'hr_shift_schedule_mode'
);

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '周排班', 'WEEKLY', 'hr_shift_schedule_mode', '', 'primary', 'Y', '0', 'admin', sysdate(), '按每周上班日生成'
from dual
where not exists (
    select 1 from sys_dict_data where dict_type = 'hr_shift_schedule_mode' and dict_value = 'WEEKLY'
);

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '轮班', 'ROTATION', 'hr_shift_schedule_mode', '', 'warning', 'N', '0', 'admin', sysdate(), '按上班天数/休息天数循环生成'
from dual
where not exists (
    select 1 from sys_dict_data where dict_type = 'hr_shift_schedule_mode' and dict_value = 'ROTATION'
);
