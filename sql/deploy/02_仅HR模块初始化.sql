-- =========================================================
-- HR模块初始化（基于已存在若依基础库）
-- 生成时间: 2026-05-22 03:11:38
-- =========================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- >>> BEGIN FILE: sql/hr_init.sql
-- HR module init SQL for RuoYi-hr

DROP TABLE IF EXISTS hr_attendance_exception;
DROP TABLE IF EXISTS hr_attendance_result;
DROP TABLE IF EXISTS hr_attendance_record;
DROP TABLE IF EXISTS hr_schedule;
DROP TABLE IF EXISTS hr_shift_period;
DROP TABLE IF EXISTS hr_shift;
DROP TABLE IF EXISTS hr_employee;
DROP TABLE IF EXISTS hr_attendance_rule;

CREATE TABLE hr_employee (
  hr_employee_id      BIGINT      NOT NULL AUTO_INCREMENT,
  user_id             BIGINT      NOT NULL,
  dept_id             BIGINT      NOT NULL,
  employee_no         VARCHAR(64) NOT NULL,
  job_type            VARCHAR(64) DEFAULT NULL,
  attend_enabled      CHAR(1)     DEFAULT '1',
  default_shift_group VARCHAR(64) DEFAULT NULL,
  device_user_no      VARCHAR(64) DEFAULT NULL,
  join_date           DATE        DEFAULT NULL,
  work_status         CHAR(1)     DEFAULT '0',
  del_flag            CHAR(1)     DEFAULT '0',
  create_by           VARCHAR(64) DEFAULT '',
  create_time         DATETIME,
  update_by           VARCHAR(64) DEFAULT '',
  update_time         DATETIME,
  remark              VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (hr_employee_id),
  UNIQUE KEY uk_hr_employee_no (employee_no),
  KEY idx_hr_employee_user (user_id),
  KEY idx_hr_employee_dept (dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='HR员工扩展表';

CREATE TABLE hr_shift (
  shift_id              BIGINT       NOT NULL AUTO_INCREMENT,
  shift_code            VARCHAR(64)  NOT NULL,
  shift_name            VARCHAR(128) NOT NULL,
  post_type             VARCHAR(64)  DEFAULT NULL,
  summer_extend_enabled CHAR(1)      DEFAULT '0',
  summer_extend_minutes INT          DEFAULT 30,
  expected_start_time   TIME         DEFAULT NULL,
  expected_end_time     TIME         DEFAULT NULL,
  status                CHAR(1)      DEFAULT '0',
  del_flag              CHAR(1)      DEFAULT '0',
  create_by             VARCHAR(64)  DEFAULT '',
  create_time           DATETIME,
  update_by             VARCHAR(64)  DEFAULT '',
  update_time           DATETIME,
  remark                VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (shift_id),
  UNIQUE KEY uk_hr_shift_code (shift_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='HR班次主表';

CREATE TABLE hr_shift_period (
  period_id    BIGINT      NOT NULL AUTO_INCREMENT,
  shift_id     BIGINT      NOT NULL,
  period_no    INT         NOT NULL,
  start_time   TIME        NOT NULL,
  end_time     TIME        NOT NULL,
  create_by    VARCHAR(64) DEFAULT '',
  create_time  DATETIME,
  update_by    VARCHAR(64) DEFAULT '',
  update_time  DATETIME,
  PRIMARY KEY (period_id),
  KEY idx_hr_shift_period_shift (shift_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='HR班次时段表';

CREATE TABLE hr_schedule (
  schedule_id      BIGINT      NOT NULL AUTO_INCREMENT,
  user_id          BIGINT      NOT NULL,
  dept_id          BIGINT      NOT NULL,
  work_date        DATE        NOT NULL,
  shift_id         BIGINT      DEFAULT NULL,
  rest_type        VARCHAR(32) DEFAULT NULL,
  schedule_remark  VARCHAR(500) DEFAULT NULL,
  create_by        VARCHAR(64) DEFAULT '',
  create_time      DATETIME,
  update_by        VARCHAR(64) DEFAULT '',
  update_time      DATETIME,
  PRIMARY KEY (schedule_id),
  UNIQUE KEY uk_hr_schedule_user_date (user_id, work_date),
  KEY idx_hr_schedule_dept_date (dept_id, work_date),
  KEY idx_hr_schedule_shift (shift_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='HR按人按天排班表';

CREATE TABLE hr_attendance_record (
  record_id      BIGINT      NOT NULL AUTO_INCREMENT,
  user_id        BIGINT      NOT NULL,
  device_user_no VARCHAR(64) DEFAULT NULL,
  punch_time     DATETIME    NOT NULL,
  source_type    VARCHAR(32) DEFAULT 'DEVICE',
  create_by      VARCHAR(64) DEFAULT '',
  create_time    DATETIME,
  PRIMARY KEY (record_id),
  KEY idx_hr_att_rec_user_time (user_id, punch_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='原始打卡记录';

CREATE TABLE hr_attendance_result (
  result_id         BIGINT      NOT NULL AUTO_INCREMENT,
  user_id           BIGINT      NOT NULL,
  dept_id           BIGINT      DEFAULT NULL,
  work_date         DATE        NOT NULL,
  shift_id          BIGINT      DEFAULT NULL,
  expected_in_time  DATETIME    DEFAULT NULL,
  expected_out_time DATETIME    DEFAULT NULL,
  actual_in_time    DATETIME    DEFAULT NULL,
  actual_out_time   DATETIME    DEFAULT NULL,
  late_flag         CHAR(1)     DEFAULT '0',
  early_flag        CHAR(1)     DEFAULT '0',
  miss_card_flag    CHAR(1)     DEFAULT '0',
  absent_flag       CHAR(1)     DEFAULT '0',
  expected_minutes  INT         DEFAULT 0,
  actual_minutes    INT         DEFAULT 0,
  create_by         VARCHAR(64) DEFAULT '',
  create_time       DATETIME,
  PRIMARY KEY (result_id),
  UNIQUE KEY uk_hr_att_result_user_date (user_id, work_date),
  KEY idx_hr_att_result_dept_date (dept_id, work_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考勤日结果';

CREATE TABLE hr_attendance_exception (
  exception_id      BIGINT      NOT NULL AUTO_INCREMENT,
  user_id           BIGINT      NOT NULL,
  work_date         DATE        NOT NULL,
  exception_type    VARCHAR(32) NOT NULL,
  exception_detail  VARCHAR(255) DEFAULT NULL,
  create_by         VARCHAR(64) DEFAULT '',
  create_time       DATETIME,
  PRIMARY KEY (exception_id),
  KEY idx_hr_att_exc_user_date (user_id, work_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考勤异常明细';

CREATE TABLE hr_attendance_rule (
  rule_id               BIGINT      NOT NULL,
  late_minutes          INT         DEFAULT 10,
  early_minutes         INT         DEFAULT 10,
  absent_minutes        INT         DEFAULT 120,
  day_close_minutes     INT         DEFAULT 120,
  multi_punch_strategy  VARCHAR(64) DEFAULT 'EARLIEST_IN_LATEST_OUT',
  create_by             VARCHAR(64) DEFAULT '',
  create_time           DATETIME,
  update_by             VARCHAR(64) DEFAULT '',
  update_time           DATETIME,
  PRIMARY KEY (rule_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考勤规则';

INSERT INTO hr_attendance_rule(rule_id, late_minutes, early_minutes, absent_minutes, day_close_minutes, multi_punch_strategy, create_by, create_time)
VALUES (1, 10, 10, 120, 120, 'EARLIEST_IN_LATEST_OUT', 'admin', sysdate());

-- 班次模板
INSERT INTO hr_shift(shift_code, shift_name, post_type, summer_extend_enabled, summer_extend_minutes, expected_start_time, expected_end_time, status, del_flag, create_by, create_time)
VALUES
('SHIFT_BREAD_1', '面点房(5:30-12:20)', '面点房', '0', 30, '05:30:00', '12:20:00', '0', '0', 'admin', sysdate()),
('SHIFT_BREAD_2', '面点房(7:30-12:30,15:30-17:00)', '面点房', '0', 30, '07:30:00', '17:00:00', '0', '0', 'admin', sysdate()),
('SHIFT_ACCEPT', '验收', '验收', '0', 30, '07:00:00', '17:30:00', '0', '0', 'admin', sysdate()),
('SHIFT_DISH', '洗碗工', '洗碗工', '1', 30, '07:00:00', '20:00:00', '0', '0', 'admin', sysdate()),
('SHIFT_COOK', '厨师', '厨师', '0', 30, '09:00:00', '18:15:00', '0', '0', 'admin', sysdate()),
('SHIFT_SERVICE', '服务员', '服务员', '0', 30, '09:00:00', '18:30:00', '0', '0', 'admin', sysdate()),
('SHIFT_EARLY', '早班', '服务员', '0', 30, '06:30:00', '13:00:00', '0', '0', 'admin', sysdate()),
('SHIFT_COFFEE', '咖啡吧', '咖啡吧', '0', 30, '08:30:00', '17:30:00', '0', '0', 'admin', sysdate()),
('SHIFT_OFFICE', '办公室', '办公室', '0', 30, '08:30:00', '17:30:00', '0', '0', 'admin', sysdate()),
('SHIFT_HYGIENE', '卫生组', '卫生组', '0', 30, '07:30:00', '16:30:00', '0', '0', 'admin', sysdate());

INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '05:30:00', '12:20:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_BREAD_1';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '07:30:00', '12:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_BREAD_2';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 2, '15:30:00', '17:00:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_BREAD_2';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '07:00:00', '12:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_ACCEPT';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 2, '15:30:00', '17:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_ACCEPT';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '07:00:00', '13:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_DISH';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 2, '15:30:00', '20:00:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_DISH';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '09:00:00', '13:00:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_COOK';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 2, '15:45:00', '18:15:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_COOK';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '09:00:00', '13:00:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_SERVICE';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 2, '16:00:00', '18:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_SERVICE';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '06:30:00', '13:00:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_EARLY';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '08:30:00', '12:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_COFFEE';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 2, '14:00:00', '17:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_COFFEE';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '08:30:00', '17:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_OFFICE';
INSERT INTO hr_shift_period(shift_id, period_no, start_time, end_time, create_by, create_time)
SELECT shift_id, 1, '07:30:00', '16:30:00', 'admin', sysdate() FROM hr_shift WHERE shift_code='SHIFT_HYGIENE';

-- 菜单与权限
INSERT INTO sys_menu VALUES(3000, 'HR管理', 0, 6, '#', '', 'M', '0', '1', '', 'fa fa-users', 'admin', sysdate(), '', null, 'HR模块');

INSERT INTO sys_menu VALUES
(3001, '组织员工', 3000, 1, '/hr/employee', '', 'C', '0', '1', 'hr:employee:view', '#', 'admin', sysdate(), '', null, ''),
(3002, '班次管理', 3000, 2, '/hr/shift', '', 'C', '0', '1', 'hr:shift:view', '#', 'admin', sysdate(), '', null, ''),
(3003, '排班管理', 3000, 3, '/hr/schedule', '', 'C', '0', '1', 'hr:schedule:view', '#', 'admin', sysdate(), '', null, ''),
(3004, '考勤处理', 3000, 4, '/hr/attendance', '', 'C', '0', '1', 'hr:attendance:view', '#', 'admin', sysdate(), '', null, ''),
(3005, '规则配置', 3000, 5, '/hr/rule', '', 'C', '0', '1', 'hr:attendance:edit', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_menu VALUES
(3011, '员工查询', 3001, 1, '#', '', 'F', '0', '1', 'hr:employee:list', '#', 'admin', sysdate(), '', null, ''),
(3012, '员工新增', 3001, 2, '#', '', 'F', '0', '1', 'hr:employee:add', '#', 'admin', sysdate(), '', null, ''),
(3013, '员工修改', 3001, 3, '#', '', 'F', '0', '1', 'hr:employee:edit', '#', 'admin', sysdate(), '', null, ''),
(3014, '员工删除', 3001, 4, '#', '', 'F', '0', '1', 'hr:employee:remove', '#', 'admin', sysdate(), '', null, ''),
(3015, '员工导出', 3001, 5, '#', '', 'F', '0', '1', 'hr:employee:export', '#', 'admin', sysdate(), '', null, ''),

(3021, '班次查询', 3002, 1, '#', '', 'F', '0', '1', 'hr:shift:list', '#', 'admin', sysdate(), '', null, ''),
(3022, '班次新增', 3002, 2, '#', '', 'F', '0', '1', 'hr:shift:add', '#', 'admin', sysdate(), '', null, ''),
(3023, '班次修改', 3002, 3, '#', '', 'F', '0', '1', 'hr:shift:edit', '#', 'admin', sysdate(), '', null, ''),
(3024, '班次删除', 3002, 4, '#', '', 'F', '0', '1', 'hr:shift:remove', '#', 'admin', sysdate(), '', null, ''),
(3025, '班次导出', 3002, 5, '#', '', 'F', '0', '1', 'hr:shift:export', '#', 'admin', sysdate(), '', null, ''),

(3031, '排班查询', 3003, 1, '#', '', 'F', '0', '1', 'hr:schedule:list', '#', 'admin', sysdate(), '', null, ''),
(3032, '排班新增', 3003, 2, '#', '', 'F', '0', '1', 'hr:schedule:add', '#', 'admin', sysdate(), '', null, ''),
(3033, '排班修改', 3003, 3, '#', '', 'F', '0', '1', 'hr:schedule:edit', '#', 'admin', sysdate(), '', null, ''),
(3034, '排班删除', 3003, 4, '#', '', 'F', '0', '1', 'hr:schedule:remove', '#', 'admin', sysdate(), '', null, ''),
(3035, '排班导出', 3003, 5, '#', '', 'F', '0', '1', 'hr:schedule:export', '#', 'admin', sysdate(), '', null, ''),

(3041, '考勤查询', 3004, 1, '#', '', 'F', '0', '1', 'hr:attendance:list', '#', 'admin', sysdate(), '', null, ''),
(3042, '考勤重算', 3004, 2, '#', '', 'F', '0', '1', 'hr:attendance:recalc', '#', 'admin', sysdate(), '', null, ''),
(3043, '考勤导出', 3004, 3, '#', '', 'F', '0', '1', 'hr:attendance:export', '#', 'admin', sysdate(), '', null, ''),
(3044, '报表查看', 3004, 4, '#', '', 'F', '0', '1', 'hr:report:view', '#', 'admin', sysdate(), '', null, '');

INSERT INTO sys_role_menu(role_id, menu_id)
SELECT 1, m.menu_id FROM sys_menu m WHERE m.menu_id BETWEEN 3000 AND 3044;

-- =========================================================
-- v1.1 班次与排班增强（可重复执行）
-- =========================================================
ALTER TABLE hr_shift ADD COLUMN  workday_mask VARCHAR(7) DEFAULT '1111100' COMMENT '每周上班掩码(周一到周日，1上班0休息)';
ALTER TABLE hr_employee ADD COLUMN default_shift_id BIGINT DEFAULT NULL COMMENT '默认班次ID';

UPDATE hr_shift SET workday_mask = '1111100' WHERE workday_mask IS NULL OR workday_mask = '';

-- <<< END FILE: sql/hr_init.sql

-- >>> BEGIN FILE: sql/hr_v2_schedule_attendance.sql
-- =========================================================
-- HR 一期增强脚本
-- 范围：员工设置、休息班次、月排班生成、考勤明细、菜单权限
-- 说明：建议在备份数据库后执行一次
-- =========================================================

-- 1. 员工 HR 扩展配置
CREATE TABLE IF NOT EXISTS hr_employee_setting (
  user_id             BIGINT       NOT NULL COMMENT 'sys_user.user_id',
  entry_date          DATE         NOT NULL COMMENT '入职日期',
  leave_date          DATE         DEFAULT NULL COMMENT '离职日期',
  default_shift_id    BIGINT       NOT NULL COMMENT '默认班次ID',
  attendance_enabled  CHAR(1)      DEFAULT '1' COMMENT '是否参与考勤(1是0否)',
  remark              VARCHAR(500) DEFAULT NULL COMMENT '备注',
  create_by           VARCHAR(64)  DEFAULT '',
  create_time         DATETIME     DEFAULT NULL,
  update_by           VARCHAR(64)  DEFAULT '',
  update_time         DATETIME     DEFAULT NULL,
  PRIMARY KEY (user_id),
  KEY idx_hes_shift (default_shift_id),
  KEY idx_hes_entry_leave (entry_date, leave_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工HR扩展配置';

-- 如果你的库里仍然保留旧 hr_employee 表，可按需手工执行下面这段迁移 SQL：
-- INSERT INTO hr_employee_setting(user_id, entry_date, leave_date, default_shift_id, attendance_enabled, remark, create_by, create_time)
-- SELECT e.user_id,
--        IFNULL(e.join_date, CURDATE()),
--        NULL,
--        e.default_shift_id,
--        IFNULL(e.attend_enabled, '1'),
--        e.remark,
--        'migration',
--        SYSDATE()
-- FROM hr_employee e
-- WHERE e.default_shift_id IS NOT NULL
--   AND NOT EXISTS (SELECT 1 FROM hr_employee_setting s WHERE s.user_id = e.user_id);

-- 2. 班次增强：休息班次标记
ALTER TABLE hr_shift
  ADD COLUMN is_rest_shift CHAR(1) DEFAULT '0' COMMENT '是否休息班次(1是0否)' AFTER workday_mask;

UPDATE hr_shift SET is_rest_shift = '0' WHERE is_rest_shift IS NULL;

-- 3. 固定休息班次
INSERT INTO hr_shift(
  shift_code, shift_name, post_type, workday_mask, is_rest_shift,
  summer_extend_enabled, summer_extend_minutes,
  expected_start_time, expected_end_time,
  status, del_flag, create_by, create_time, remark
)
SELECT
  'SHIFT_REST', '休息', '通用', '0000000', '1',
  '0', 0,
  NULL, NULL,
  '0', '0', 'admin', SYSDATE(), '系统固定休息班次'
FROM dual
WHERE NOT EXISTS (
  SELECT 1 FROM hr_shift WHERE shift_code = 'SHIFT_REST'
);

-- 4. 排班增强字段
ALTER TABLE hr_schedule
  ADD COLUMN schedule_month CHAR(7) DEFAULT NULL COMMENT '排班月份yyyy-MM' AFTER work_date,
  ADD COLUMN generate_source VARCHAR(32) DEFAULT 'MANUAL_ADD' COMMENT '生成来源' AFTER rest_type,
  ADD COLUMN manual_modified CHAR(1) DEFAULT '0' COMMENT '是否人工修改(1是0否)' AFTER generate_source;

UPDATE hr_schedule
SET schedule_month = DATE_FORMAT(work_date, '%Y-%m')
WHERE schedule_month IS NULL OR schedule_month = '';

UPDATE hr_schedule
SET generate_source = 'MANUAL_ADD'
WHERE generate_source IS NULL OR generate_source = '';

UPDATE hr_schedule
SET manual_modified = '1'
WHERE manual_modified IS NULL OR manual_modified = '';

-- 5. 历史空班次数据回填成休息班次
UPDATE hr_schedule s
JOIN hr_shift sh ON sh.shift_code = 'SHIFT_REST'
SET s.shift_id = sh.shift_id,
    s.rest_type = IFNULL(NULLIF(s.rest_type, ''), 'REST')
WHERE s.shift_id IS NULL;

ALTER TABLE hr_schedule
  MODIFY COLUMN shift_id BIGINT NOT NULL COMMENT '班次ID';

ALTER TABLE hr_schedule
  ADD KEY idx_hr_schedule_month (schedule_month),
  ADD KEY idx_hr_schedule_source (generate_source),
  ADD KEY idx_hr_schedule_user_month (user_id, schedule_month);

-- 6. 考勤结果扩展为考勤明细
ALTER TABLE hr_attendance_result
  ADD COLUMN schedule_id BIGINT DEFAULT NULL COMMENT '对应排班ID' AFTER work_date,
  ADD COLUMN login_name VARCHAR(64) DEFAULT NULL COMMENT '工号' AFTER user_id,
  ADD COLUMN rest_type VARCHAR(32) DEFAULT NULL COMMENT '休息类型' AFTER shift_id,
  ADD COLUMN attendance_status VARCHAR(32) DEFAULT 'PENDING_CLOCK' COMMENT '考勤状态' AFTER rest_type,
  ADD COLUMN exception_type VARCHAR(64) DEFAULT NULL COMMENT '异常类型' AFTER attendance_status,
  ADD COLUMN punch_count INT DEFAULT 0 COMMENT '打卡次数' AFTER actual_out_time,
  ADD COLUMN data_source VARCHAR(32) DEFAULT 'SCHEDULE' COMMENT '数据来源' AFTER punch_count,
  ADD COLUMN remark VARCHAR(500) DEFAULT NULL COMMENT '备注' AFTER data_source;

ALTER TABLE hr_attendance_result
  ADD KEY idx_hr_att_result_schedule (schedule_id),
  ADD KEY idx_hr_att_result_user_month (user_id, work_date);

-- 7. 菜单与权限：员工设置 / 考勤明细 / 排班生成
UPDATE sys_menu SET menu_name = '员工设置', url = '/hr/employeeSetting', perms = 'hr:employeeSetting:view' WHERE menu_id = 3001;
UPDATE sys_menu SET menu_name = '考勤明细' WHERE menu_id = 3004;

DELETE FROM sys_role_menu WHERE menu_id BETWEEN 3011 AND 3015;
DELETE FROM sys_menu WHERE menu_id BETWEEN 3011 AND 3015;

INSERT IGNORE INTO sys_menu VALUES
(3011, '员工设置查询', 3001, 1, '#', '', 'F', '0', '1', 'hr:employeeSetting:list', '#', 'admin', SYSDATE(), '', NULL, ''),
(3012, '员工设置修改', 3001, 2, '#', '', 'F', '0', '1', 'hr:employeeSetting:edit', '#', 'admin', SYSDATE(), '', NULL, ''),
(3013, '员工设置导出', 3001, 3, '#', '', 'F', '0', '1', 'hr:employeeSetting:export', '#', 'admin', SYSDATE(), '', NULL, '');

INSERT IGNORE INTO sys_menu VALUES
(3036, '生成月排班', 3003, 6, '#', '', 'F', '0', '1', 'hr:schedule:generate', '#', 'admin', SYSDATE(), '', NULL, ''),
(3037, '更新排班', 3003, 7, '#', '', 'F', '0', '1', 'hr:schedule:updateRange', '#', 'admin', SYSDATE(), '', NULL, '');

INSERT IGNORE INTO sys_menu VALUES
(3045, '生成月考勤', 3004, 5, '#', '', 'F', '0', '1', 'hr:attendance:generate', '#', 'admin', SYSDATE(), '', NULL, ''),
(3046, '未来七天同步', 3004, 6, '#', '', 'F', '0', '1', 'hr:attendance:recalc', '#', 'admin', SYSDATE(), '', NULL, '');

INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, m.menu_id
FROM sys_menu m
WHERE m.menu_id IN (3011, 3012, 3013, 3036, 3037, 3045, 3046);

-- 8. 定时任务建议（在系统监控 -> 定时任务中新增）
-- 排班：调用目标  hrTask.syncFutureSevenDaysSchedule()
-- 考勤：调用目标  hrTask.syncFutureSevenDaysAttendance()
-- 建议 Cron：
-- 排班   0 5 0 * * ?
-- 考勤   0 20 0 * * ?

-- <<< END FILE: sql/hr_v2_schedule_attendance.sql

-- >>> BEGIN FILE: sql/hr_v3_attendance_rule_demo.sql
-- =========================================================
-- HR 考勤规则增强 + 演示打卡支持
-- 适用范围：已有 hr_v2 的基础上继续执行
-- =========================================================

ALTER TABLE hr_attendance_rule
  ADD COLUMN day_close_minutes INT DEFAULT 120 COMMENT '下班后封存分钟' AFTER absent_minutes;

UPDATE hr_attendance_rule
SET late_minutes = IFNULL(late_minutes, 10),
    early_minutes = IFNULL(early_minutes, 10),
    absent_minutes = IFNULL(absent_minutes, 120),
    day_close_minutes = IFNULL(day_close_minutes, 120),
    multi_punch_strategy = IFNULL(NULLIF(multi_punch_strategy, ''), 'EARLIEST_IN_LATEST_OUT')
WHERE rule_id = 1;

INSERT INTO hr_attendance_rule(rule_id, late_minutes, early_minutes, absent_minutes, day_close_minutes, multi_punch_strategy, create_by, create_time, update_by, update_time)
SELECT 1, 10, 10, 120, 120, 'EARLIEST_IN_LATEST_OUT', 'admin', SYSDATE(), 'admin', SYSDATE()
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hr_attendance_rule WHERE rule_id = 1);

-- 可选：如需给管理员增加“生成演示打卡”权限，可执行以下 SQL
INSERT IGNORE INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3047, '生成演示打卡', 3004, 7, '#', '', 'F', '0', '1', 'hr:attendance:generate', '#', 'admin', SYSDATE(), '', NULL, '');

INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
VALUES (1, 3047);

-- <<< END FILE: sql/hr_v3_attendance_rule_demo.sql

-- >>> BEGIN FILE: sql/hr_v4_attendance_record.sql
SET NAMES utf8mb4;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN login_name VARCHAR(64) DEFAULT NULL AFTER user_id',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'login_name'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN user_name_snapshot VARCHAR(64) DEFAULT NULL AFTER login_name',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'user_name_snapshot'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN dept_id_snapshot BIGINT DEFAULT NULL AFTER user_name_snapshot',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'dept_id_snapshot'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN dept_name_snapshot VARCHAR(128) DEFAULT NULL AFTER dept_id_snapshot',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'dept_name_snapshot'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN device_name VARCHAR(128) DEFAULT NULL AFTER source_type',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'device_name'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN device_no VARCHAR(64) DEFAULT NULL AFTER device_name',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'device_no'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN device_area VARCHAR(128) DEFAULT NULL AFTER device_no',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'device_area'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN punch_type VARCHAR(32) DEFAULT NULL AFTER device_area',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'punch_type'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN sync_batch_no VARCHAR(64) DEFAULT NULL AFTER punch_type',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'sync_batch_no'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN sync_time DATETIME DEFAULT NULL AFTER sync_batch_no',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'sync_time'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN record_status VARCHAR(32) DEFAULT ''VALID'' AFTER sync_time',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'record_status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN invalid_reason VARCHAR(255) DEFAULT NULL AFTER record_status',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'invalid_reason'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN source_db_key VARCHAR(128) DEFAULT NULL AFTER invalid_reason',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'source_db_key'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN update_by VARCHAR(64) DEFAULT '''' AFTER create_time',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'update_by'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD COLUMN update_time DATETIME DEFAULT NULL AFTER update_by',
              'SELECT 1')
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND COLUMN_NAME = 'update_time'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD INDEX idx_hr_att_record_punch_time (punch_time)',
              'SELECT 1')
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND INDEX_NAME = 'idx_hr_att_record_punch_time'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD INDEX idx_hr_att_record_login_name (login_name)',
              'SELECT 1')
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND INDEX_NAME = 'idx_hr_att_record_login_name'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD INDEX idx_hr_att_record_batch_no (sync_batch_no)',
              'SELECT 1')
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND INDEX_NAME = 'idx_hr_att_record_batch_no'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
    SELECT IF(COUNT(*) = 0,
              'ALTER TABLE hr_attendance_record ADD INDEX idx_hr_att_record_status (record_status)',
              'SELECT 1')
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'hr_attendance_record' AND INDEX_NAME = 'idx_hr_att_record_status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS hr_attendance_sync_log (
    log_id         BIGINT NOT NULL AUTO_INCREMENT,
    batch_no       VARCHAR(64) NOT NULL,
    trigger_type   VARCHAR(32) DEFAULT 'MANUAL',
    source_type    VARCHAR(32) DEFAULT 'DEVICE_DB',
    status         VARCHAR(32) DEFAULT 'SUCCESS',
    start_time     DATETIME DEFAULT NULL,
    end_time       DATETIME DEFAULT NULL,
    total_count    INT DEFAULT 0,
    success_count  INT DEFAULT 0,
    fail_count     INT DEFAULT 0,
    message        VARCHAR(500) DEFAULT NULL,
    create_by      VARCHAR(64) DEFAULT '',
    create_time    DATETIME DEFAULT NULL,
    update_by      VARCHAR(64) DEFAULT '',
    update_time    DATETIME DEFAULT NULL,
    remark         VARCHAR(500) DEFAULT NULL,
    PRIMARY KEY (log_id),
    KEY idx_hr_att_sync_batch (batch_no),
    KEY idx_hr_att_sync_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

UPDATE hr_attendance_record r
LEFT JOIN sys_user u ON u.user_id = r.user_id
LEFT JOIN sys_dept d ON d.dept_id = u.dept_id
SET r.login_name = COALESCE(r.login_name, u.login_name),
    r.user_name_snapshot = COALESCE(r.user_name_snapshot, u.user_name),
    r.dept_id_snapshot = COALESCE(r.dept_id_snapshot, u.dept_id),
    r.dept_name_snapshot = COALESCE(r.dept_name_snapshot, d.dept_name),
    r.device_no = COALESCE(r.device_no, r.device_user_no),
    r.sync_time = COALESCE(r.sync_time, r.create_time),
    r.record_status = CASE
        WHEN r.record_status IS NULL OR r.record_status = '' THEN 'VALID'
        ELSE r.record_status
    END,
    r.source_type = CASE
        WHEN r.source_type IS NULL OR r.source_type = '' THEN 'DEVICE'
        ELSE r.source_type
    END,
    r.source_db_key = COALESCE(r.source_db_key, CONCAT('LOCAL-', r.record_id));

UPDATE sys_menu SET order_num = 7 WHERE menu_id = 3005 AND parent_id = 3000;

INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 3006, CONVERT(0xE68993E58DA1E8AEB0E5BD95 USING utf8mb4), 3000, 5, '/hr/attendanceRecord', '', 'C', '0', '1', 'hr:attendanceRecord:view', '#', 'admin', SYSDATE(), '', NULL, ''
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 3006);

INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 3007, CONVERT(0xE5908CE6ADA5E697A5E5BF97 USING utf8mb4), 3000, 6, '/hr/attendanceRecord/syncLog', '', 'C', '0', '1', 'hr:attendanceSync:view', '#', 'admin', SYSDATE(), '', NULL, ''
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 3007);

INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 3051, CONVERT(0xE68993E58DA1E8AEB0E5BD95E69FA5E8AFA2 USING utf8mb4), 3006, 1, '#', '', 'F', '0', '1', 'hr:attendanceRecord:list', '#', 'admin', SYSDATE(), '', NULL, ''
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 3051);

INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 3052, CONVERT(0xE68993E58DA1E8AEB0E5BD95E5AFBCE587BA USING utf8mb4), 3006, 2, '#', '', 'F', '0', '1', 'hr:attendanceRecord:export', '#', 'admin', SYSDATE(), '', NULL, ''
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 3052);

INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 3053, CONVERT(0xE88083E58BA4E69CBAE5908CE6ADA5 USING utf8mb4), 3006, 3, '#', '', 'F', '0', '1', 'hr:attendanceRecord:sync', '#', 'admin', SYSDATE(), '', NULL, ''
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 3053);

INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 3061, CONVERT(0xE5908CE6ADA5E697A5E5BF97E69FA5E8AFA2 USING utf8mb4), 3007, 1, '#', '', 'F', '0', '1', 'hr:attendanceSync:list', '#', 'admin', SYSDATE(), '', NULL, ''
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 3061);

INSERT INTO sys_role_menu(role_id, menu_id)
SELECT 1, 3006 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 3006);

INSERT INTO sys_role_menu(role_id, menu_id)
SELECT 1, 3007 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 3007);

INSERT INTO sys_role_menu(role_id, menu_id)
SELECT 1, 3051 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 3051);

INSERT INTO sys_role_menu(role_id, menu_id)
SELECT 1, 3052 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 3052);

INSERT INTO sys_role_menu(role_id, menu_id)
SELECT 1, 3053 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 3053);

INSERT INTO sys_role_menu(role_id, menu_id)
SELECT 1, 3061 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 3061);

UPDATE sys_menu SET menu_name = CONVERT(0xE68993E58DA1E8AEB0E5BD95 USING utf8mb4), url = '/hr/attendanceRecord', perms = 'hr:attendanceRecord:view' WHERE menu_id = 3006;
UPDATE sys_menu SET menu_name = CONVERT(0xE5908CE6ADA5E697A5E5BF97 USING utf8mb4), url = '/hr/attendanceRecord/syncLog', perms = 'hr:attendanceSync:view' WHERE menu_id = 3007;
UPDATE sys_menu SET menu_name = CONVERT(0xE68993E58DA1E8AEB0E5BD95E69FA5E8AFA2 USING utf8mb4), perms = 'hr:attendanceRecord:list' WHERE menu_id = 3051;
UPDATE sys_menu SET menu_name = CONVERT(0xE68993E58DA1E8AEB0E5BD95E5AFBCE587BA USING utf8mb4), perms = 'hr:attendanceRecord:export' WHERE menu_id = 3052;
UPDATE sys_menu SET menu_name = CONVERT(0xE88083E58BA4E69CBAE5908CE6ADA5 USING utf8mb4), perms = 'hr:attendanceRecord:sync' WHERE menu_id = 3053;
UPDATE sys_menu SET menu_name = CONVERT(0xE5908CE6ADA5E697A5E5BF97E69FA5E8AFA2 USING utf8mb4), perms = 'hr:attendanceSync:list' WHERE menu_id = 3061;

-- <<< END FILE: sql/hr_v4_attendance_record.sql

-- >>> BEGIN FILE: sql/hr_v5_shift_segment.sql
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
-- <<< END FILE: sql/hr_v5_shift_segment.sql

-- >>> BEGIN FILE: sql/hr_v6_attendance_result_segment.sql
create table if not exists hr_attendance_result_segment (
  segment_result_id bigint not null auto_increment,
  result_id bigint not null,
  schedule_id bigint default null,
  user_id bigint not null,
  work_date date not null,
  shift_id bigint default null,
  segment_no int not null,
  segment_name varchar(64) default null,
  plan_in_time datetime default null,
  plan_out_time datetime default null,
  valid_begin_time datetime default null,
  valid_end_time datetime default null,
  actual_in_time datetime default null,
  actual_out_time datetime default null,
  need_in_punch char(1) default '1',
  need_out_punch char(1) default '1',
  punch_count int default 0,
  segment_status varchar(32) default 'PENDING_CLOCK',
  late_flag char(1) default '0',
  early_flag char(1) default '0',
  miss_card_flag char(1) default '0',
  absent_flag char(1) default '0',
  work_minutes int default 0,
  remark varchar(200) default null,
  create_by varchar(64) default '',
  create_time datetime default null,
  update_by varchar(64) default '',
  update_time datetime default null,
  primary key (segment_result_id),
  unique key uk_hr_att_result_segment (result_id, segment_no),
  key idx_hr_att_result_segment_user_date (user_id, work_date),
  key idx_hr_att_result_segment_schedule (schedule_id)
) engine=InnoDB default charset=utf8mb4 comment='考勤班段结果表';
-- <<< END FILE: sql/hr_v6_attendance_result_segment.sql

-- >>> BEGIN FILE: sql/hr_v7_dict.sql
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

-- <<< END FILE: sql/hr_v7_dict.sql

-- >>> BEGIN FILE: sql/hr_v8_rotation_annual.sql
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

-- <<< END FILE: sql/hr_v8_rotation_annual.sql

-- >>> BEGIN FILE: sql/hr_v9_text_cleanup.sql
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


-- <<< END FILE: sql/hr_v9_text_cleanup.sql

SET FOREIGN_KEY_CHECKS = 1;
