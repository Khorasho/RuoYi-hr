set @db_name = database();

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift_period' and column_name = 'segment_name'
    ),
    'select 1',
    'alter table hr_shift_period add column segment_name varchar(64) default null comment ''班段名称'' after period_no'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift_period' and column_name = 'valid_begin_time'
    ),
    'select 1',
    'alter table hr_shift_period add column valid_begin_time time default null comment ''有效打卡开始'' after end_time'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift_period' and column_name = 'valid_end_time'
    ),
    'select 1',
    'alter table hr_shift_period add column valid_end_time time default null comment ''有效打卡结束'' after valid_begin_time'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift_period' and column_name = 'need_in_punch'
    ),
    'select 1',
    'alter table hr_shift_period add column need_in_punch char(1) default ''1'' comment ''是否要求上班打卡(1是0否)'' after valid_end_time'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift_period' and column_name = 'need_out_punch'
    ),
    'select 1',
    'alter table hr_shift_period add column need_out_punch char(1) default ''1'' comment ''是否要求下班打卡(1是0否)'' after need_in_punch'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift_period' and column_name = 'cross_day'
    ),
    'select 1',
    'alter table hr_shift_period add column cross_day char(1) default ''0'' comment ''是否跨天(1是0否)'' after need_out_punch'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.columns
        where table_schema = @db_name and table_name = 'hr_shift_period' and column_name = 'segment_remark'
    ),
    'select 1',
    'alter table hr_shift_period add column segment_remark varchar(200) default null comment ''班段备注'' after cross_day'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

set @sql = if (
    exists (
        select 1 from information_schema.statistics
        where table_schema = @db_name and table_name = 'hr_shift_period' and index_name = 'idx_hr_shift_period_shift_no'
    ),
    'select 1',
    'alter table hr_shift_period add key idx_hr_shift_period_shift_no (shift_id, period_no)'
);
prepare stmt from @sql; execute stmt; deallocate prepare stmt;

update hr_shift_period
set segment_name = concat('第', period_no, '段')
where segment_name is null or segment_name = '';

update hr_shift_period
set valid_begin_time = start_time
where valid_begin_time is null;

update hr_shift_period
set valid_end_time = end_time
where valid_end_time is null;

update hr_shift_period
set need_in_punch = '1'
where need_in_punch is null or need_in_punch = '';

update hr_shift_period
set need_out_punch = '1'
where need_out_punch is null or need_out_punch = '';

update hr_shift_period
set cross_day = '0'
where cross_day is null or cross_day = '';