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
