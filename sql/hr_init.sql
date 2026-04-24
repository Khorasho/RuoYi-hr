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
  late_minutes          INT         DEFAULT 0,
  early_minutes         INT         DEFAULT 0,
  absent_minutes        INT         DEFAULT 120,
  multi_punch_strategy  VARCHAR(64) DEFAULT 'EARLIEST_IN_LATEST_OUT',
  create_by             VARCHAR(64) DEFAULT '',
  create_time           DATETIME,
  update_by             VARCHAR(64) DEFAULT '',
  update_time           DATETIME,
  PRIMARY KEY (rule_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考勤规则';

INSERT INTO hr_attendance_rule(rule_id, late_minutes, early_minutes, absent_minutes, multi_punch_strategy, create_by, create_time)
VALUES (1, 0, 0, 120, 'EARLIEST_IN_LATEST_OUT', 'admin', sysdate());

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
