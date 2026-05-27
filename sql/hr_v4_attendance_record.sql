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
