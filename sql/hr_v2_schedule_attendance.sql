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
