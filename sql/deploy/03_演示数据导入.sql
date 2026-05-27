-- =========================================================
-- HR演示数据导入与乱码修复
-- 生成时间: 2026-05-22 03:11:38
-- =========================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- >>> BEGIN FILE: sql/hr_mock_users_full.sql
SET NAMES utf8mb4;
-- 补全现有测试员工 101-110 的员工设置
REPLACE INTO hr_employee_setting (user_id, entry_date, leave_date, default_shift_id, attendance_enabled, remark, create_by, create_time, update_by, update_time) VALUES
(101, '2026-03-18', NULL, 11, '1', '测试数据-面点房', 'admin', NOW(), 'admin', NOW()),
(102, '2026-03-20', NULL, 12, '1', '测试数据-面点房2', 'admin', NOW(), 'admin', NOW()),
(103, '2026-03-15', NULL, 6, '1', '测试数据-服务员', 'admin', NOW(), 'admin', NOW()),
(104, '2026-03-12', NULL, 3, '1', '测试数据-验收', 'admin', NOW(), 'admin', NOW()),
(105, '2026-03-10', NULL, 5, '1', '测试数据-厨师', 'admin', NOW(), 'admin', NOW()),
(106, '2026-02-28', NULL, 9, '1', '测试数据-办公室', 'admin', NOW(), 'admin', NOW()),
(107, '2026-03-05', NULL, 10, '1', '测试数据-卫生组', 'admin', NOW(), 'admin', NOW()),
(108, '2026-03-08', NULL, 7, '1', '测试数据-早班', 'admin', NOW(), 'admin', NOW()),
(109, '2026-03-01', NULL, 8, '1', '测试数据-咖啡吧', 'admin', NOW(), 'admin', NOW()),
(110, '2026-03-22', NULL, 4, '1', '测试数据-洗碗工', 'admin', NOW(), 'admin', NOW());

-- 新增更多测试员工 111-140
INSERT INTO sys_user (user_id, dept_id, login_name, user_name, user_type, email, phonenumber, sex, avatar, password, salt, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark) VALUES
(111,103,'E1011','刘洋','00','e1011@test.local','13800001011','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(112,103,'E1012','黄莉','00','e1012@test.local','13800001012','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(113,104,'E1013','许峰','00','e1013@test.local','13800001013','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(114,105,'E1014','邓敏','00','e1014@test.local','13800001014','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(115,106,'E1015','谢军','00','e1015@test.local','13800001015','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(116,107,'E1016','宋洁','00','e1016@test.local','13800001016','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(117,103,'E1017','唐磊','00','e1017@test.local','13800001017','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(118,104,'E1018','冯倩','00','e1018@test.local','13800001018','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(119,105,'E1019','韩超','00','e1019@test.local','13800001019','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(120,107,'E1020','曹静','00','e1020@test.local','13800001020','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(121,103,'E1021','潘伟','00','e1021@test.local','13800001021','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(122,104,'E1022','袁婷','00','e1022@test.local','13800001022','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(123,105,'E1023','董凯','00','e1023@test.local','13800001023','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(124,106,'E1024','余娜','00','e1024@test.local','13800001024','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(125,107,'E1025','苏强','00','e1025@test.local','13800001025','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(126,103,'E1026','吕媛','00','e1026@test.local','13800001026','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(127,104,'E1027','程浩','00','e1027@test.local','13800001027','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(128,105,'E1028','魏璐','00','e1028@test.local','13800001028','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(129,106,'E1029','蒋博','00','e1029@test.local','13800001029','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(130,107,'E1030','沈琳','00','e1030@test.local','13800001030','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(131,103,'E1031','彭涛','00','e1031@test.local','13800001031','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(132,104,'E1032','孔雪','00','e1032@test.local','13800001032','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(133,105,'E1033','段杰','00','e1033@test.local','13800001033','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(134,106,'E1034','雷芳','00','e1034@test.local','13800001034','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(135,107,'E1035','侯健','00','e1035@test.local','13800001035','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(136,103,'E1036','龙梅','00','e1036@test.local','13800001036','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(137,104,'E1037','白晨','00','e1037@test.local','13800001037','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(138,105,'E1038','龚佳','00','e1038@test.local','13800001038','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(139,106,'E1039','黎鹏','00','e1039@test.local','13800001039','0','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工'),
(140,107,'E1040','孟姗','00','e1040@test.local','13800001040','1','', 'a66338a475aa8db4e6d1d05861352306','', '0','0','','2026-05-07 00:00:00',NOW(),'admin',NOW(),'admin',NOW(),'测试员工');

INSERT INTO sys_user_role (user_id, role_id) VALUES
(111,2),(112,2),(113,2),(114,2),(115,2),(116,2),(117,2),(118,2),(119,2),(120,2),
(121,2),(122,2),(123,2),(124,2),(125,2),(126,2),(127,2),(128,2),(129,2),(130,2),
(131,2),(132,2),(133,2),(134,2),(135,2),(136,2),(137,2),(138,2),(139,2),(140,2);

INSERT INTO sys_user_post (user_id, post_id) VALUES
(111,4),(112,4),(113,4),(114,4),(115,3),(116,4),(117,4),(118,4),(119,4),(120,4),
(121,2),(122,4),(123,4),(124,3),(125,4),(126,4),(127,4),(128,4),(129,2),(130,4),
(131,4),(132,4),(133,4),(134,3),(135,4),(136,4),(137,2),(138,4),(139,4),(140,4);

REPLACE INTO hr_employee_setting (user_id, entry_date, leave_date, default_shift_id, attendance_enabled, remark, create_by, create_time, update_by, update_time) VALUES
(111,'2026-03-01',NULL,11,'1','测试数据-面点房','admin',NOW(),'admin',NOW()),
(112,'2026-03-02',NULL,12,'1','测试数据-面点房2','admin',NOW(),'admin',NOW()),
(113,'2026-03-03',NULL,6,'1','测试数据-服务员','admin',NOW(),'admin',NOW()),
(114,'2026-03-04',NULL,3,'1','测试数据-验收','admin',NOW(),'admin',NOW()),
(115,'2026-03-05',NULL,9,'1','测试数据-办公室','admin',NOW(),'admin',NOW()),
(116,'2026-03-06',NULL,10,'1','测试数据-卫生组','admin',NOW(),'admin',NOW()),
(117,'2026-03-07',NULL,7,'1','测试数据-早班','admin',NOW(),'admin',NOW()),
(118,'2026-03-08',NULL,8,'1','测试数据-咖啡吧','admin',NOW(),'admin',NOW()),
(119,'2026-03-09',NULL,4,'1','测试数据-洗碗工','admin',NOW(),'admin',NOW()),
(120,'2026-03-10',NULL,5,'1','测试数据-厨师','admin',NOW(),'admin',NOW()),
(121,'2026-03-11',NULL,1,'1','测试数据-面点房早段','admin',NOW(),'admin',NOW()),
(122,'2026-03-12',NULL,2,'1','测试数据-面点房双时段','admin',NOW(),'admin',NOW()),
(123,'2026-03-13',NULL,6,'1','测试数据-服务员','admin',NOW(),'admin',NOW()),
(124,'2026-03-14',NULL,9,'1','测试数据-办公室','admin',NOW(),'admin',NOW()),
(125,'2026-03-15',NULL,10,'1','测试数据-卫生组','admin',NOW(),'admin',NOW()),
(126,'2026-03-16',NULL,7,'1','测试数据-早班','admin',NOW(),'admin',NOW()),
(127,'2026-03-17',NULL,8,'1','测试数据-咖啡吧','admin',NOW(),'admin',NOW()),
(128,'2026-03-18',NULL,4,'1','测试数据-洗碗工','admin',NOW(),'admin',NOW()),
(129,'2026-03-19',NULL,5,'1','测试数据-厨师','admin',NOW(),'admin',NOW()),
(130,'2026-03-20',NULL,3,'1','测试数据-验收','admin',NOW(),'admin',NOW()),
(131,'2026-03-21',NULL,11,'1','测试数据-面点房','admin',NOW(),'admin',NOW()),
(132,'2026-03-22',NULL,12,'1','测试数据-面点房2','admin',NOW(),'admin',NOW()),
(133,'2026-03-23',NULL,6,'1','测试数据-服务员','admin',NOW(),'admin',NOW()),
(134,'2026-03-24',NULL,9,'1','测试数据-办公室','admin',NOW(),'admin',NOW()),
(135,'2026-03-25',NULL,10,'1','测试数据-卫生组','admin',NOW(),'admin',NOW()),
(136,'2026-03-26',NULL,7,'1','测试数据-早班','admin',NOW(),'admin',NOW()),
(137,'2026-03-27',NULL,8,'1','测试数据-咖啡吧','admin',NOW(),'admin',NOW()),
(138,'2026-03-28',NULL,4,'1','测试数据-洗碗工','admin',NOW(),'admin',NOW()),
(139,'2026-03-29',NULL,5,'1','测试数据-厨师','admin',NOW(),'admin',NOW()),
(140,'2026-03-30',NULL,3,'1','测试数据-验收','admin',NOW(),'admin',NOW());

-- 统一修正测试员工姓名，避免命令行导入时因终端编码导致中文被写成 ??
UPDATE sys_user SET user_name = CONVERT(0xE5BCA0E6958F USING utf8mb4) WHERE user_id = 101;
UPDATE sys_user SET user_name = CONVERT(0xE69D8EE5A9B7 USING utf8mb4) WHERE user_id = 102;
UPDATE sys_user SET user_name = CONVERT(0xE78E8BE8B685 USING utf8mb4) WHERE user_id = 103;
UPDATE sys_user SET user_name = CONVERT(0xE8B5B5E99BAA USING utf8mb4) WHERE user_id = 104;
UPDATE sys_user SET user_name = CONVERT(0xE99988E6B69B USING utf8mb4) WHERE user_id = 105;
UPDATE sys_user SET user_name = CONVERT(0xE591A8E580A9 USING utf8mb4) WHERE user_id = 106;
UPDATE sys_user SET user_name = CONVERT(0xE5AD99E6B5A9 USING utf8mb4) WHERE user_id = 107;
UPDATE sys_user SET user_name = CONVERT(0xE590B4E99D99 USING utf8mb4) WHERE user_id = 108;
UPDATE sys_user SET user_name = CONVERT(0xE98391E587AF USING utf8mb4) WHERE user_id = 109;
UPDATE sys_user SET user_name = CONVERT(0xE4BD95E790B3 USING utf8mb4) WHERE user_id = 110;
UPDATE sys_user SET user_name = CONVERT(0xE58898E6B48B USING utf8mb4) WHERE user_id = 111;
UPDATE sys_user SET user_name = CONVERT(0xE9BB84E88E89 USING utf8mb4) WHERE user_id = 112;
UPDATE sys_user SET user_name = CONVERT(0xE8AEB8E5B3B0 USING utf8mb4) WHERE user_id = 113;
UPDATE sys_user SET user_name = CONVERT(0xE98293E6958F USING utf8mb4) WHERE user_id = 114;
UPDATE sys_user SET user_name = CONVERT(0xE8B0A2E5869B USING utf8mb4) WHERE user_id = 115;
UPDATE sys_user SET user_name = CONVERT(0xE5AE8BE6B481 USING utf8mb4) WHERE user_id = 116;
UPDATE sys_user SET user_name = CONVERT(0xE59490E7A38A USING utf8mb4) WHERE user_id = 117;
UPDATE sys_user SET user_name = CONVERT(0xE586AFE580A9 USING utf8mb4) WHERE user_id = 118;
UPDATE sys_user SET user_name = CONVERT(0xE99FA9E8B685 USING utf8mb4) WHERE user_id = 119;
UPDATE sys_user SET user_name = CONVERT(0xE69BB9E99D99 USING utf8mb4) WHERE user_id = 120;
UPDATE sys_user SET user_name = CONVERT(0xE6BD98E4BC9F USING utf8mb4) WHERE user_id = 121;
UPDATE sys_user SET user_name = CONVERT(0xE8A281E5A9B7 USING utf8mb4) WHERE user_id = 122;
UPDATE sys_user SET user_name = CONVERT(0xE891A3E587AF USING utf8mb4) WHERE user_id = 123;
UPDATE sys_user SET user_name = CONVERT(0xE4BD99E5A89C USING utf8mb4) WHERE user_id = 124;
UPDATE sys_user SET user_name = CONVERT(0xE88B8FE5BCBA USING utf8mb4) WHERE user_id = 125;
UPDATE sys_user SET user_name = CONVERT(0xE59095E5AA9B USING utf8mb4) WHERE user_id = 126;
UPDATE sys_user SET user_name = CONVERT(0xE7A88BE6B5A9 USING utf8mb4) WHERE user_id = 127;
UPDATE sys_user SET user_name = CONVERT(0xE9AD8FE79290 USING utf8mb4) WHERE user_id = 128;
UPDATE sys_user SET user_name = CONVERT(0xE8928BE58D9A USING utf8mb4) WHERE user_id = 129;
UPDATE sys_user SET user_name = CONVERT(0xE6B288E790B3 USING utf8mb4) WHERE user_id = 130;
UPDATE sys_user SET user_name = CONVERT(0xE5BDADE6B69B USING utf8mb4) WHERE user_id = 131;
UPDATE sys_user SET user_name = CONVERT(0xE5AD94E99BAA USING utf8mb4) WHERE user_id = 132;
UPDATE sys_user SET user_name = CONVERT(0xE6AEB5E69DB0 USING utf8mb4) WHERE user_id = 133;
UPDATE sys_user SET user_name = CONVERT(0xE99BB7E88AB3 USING utf8mb4) WHERE user_id = 134;
UPDATE sys_user SET user_name = CONVERT(0xE4BEAFE581A5 USING utf8mb4) WHERE user_id = 135;
UPDATE sys_user SET user_name = CONVERT(0xE9BE99E6A285 USING utf8mb4) WHERE user_id = 136;
UPDATE sys_user SET user_name = CONVERT(0xE799BDE699A8 USING utf8mb4) WHERE user_id = 137;
UPDATE sys_user SET user_name = CONVERT(0xE9BE9AE4BDB3 USING utf8mb4) WHERE user_id = 138;
UPDATE sys_user SET user_name = CONVERT(0xE9BB8EE9B98F USING utf8mb4) WHERE user_id = 139;
UPDATE sys_user SET user_name = CONVERT(0xE5AD9FE5A797 USING utf8mb4) WHERE user_id = 140;

-- <<< END FILE: sql/hr_mock_users_full.sql

-- >>> BEGIN FILE: sql/fix_user_names.sql
SET NAMES utf8mb4;
UPDATE sys_user SET user_name = CONVERT(0xE5BCA0E6958F USING utf8mb4) WHERE user_id = 101;
UPDATE sys_user SET user_name = CONVERT(0xE69D8EE5A9B7 USING utf8mb4) WHERE user_id = 102;
UPDATE sys_user SET user_name = CONVERT(0xE78E8BE8B685 USING utf8mb4) WHERE user_id = 103;
UPDATE sys_user SET user_name = CONVERT(0xE8B5B5E99BAA USING utf8mb4) WHERE user_id = 104;
UPDATE sys_user SET user_name = CONVERT(0xE99988E6B69B USING utf8mb4) WHERE user_id = 105;
UPDATE sys_user SET user_name = CONVERT(0xE591A8E580A9 USING utf8mb4) WHERE user_id = 106;
UPDATE sys_user SET user_name = CONVERT(0xE5AD99E6B5A9 USING utf8mb4) WHERE user_id = 107;
UPDATE sys_user SET user_name = CONVERT(0xE590B4E99D99 USING utf8mb4) WHERE user_id = 108;
UPDATE sys_user SET user_name = CONVERT(0xE98391E587AF USING utf8mb4) WHERE user_id = 109;
UPDATE sys_user SET user_name = CONVERT(0xE4BD95E790B3 USING utf8mb4) WHERE user_id = 110;
UPDATE sys_user SET user_name = CONVERT(0xE58898E6B48B USING utf8mb4) WHERE user_id = 111;
UPDATE sys_user SET user_name = CONVERT(0xE9BB84E88E89 USING utf8mb4) WHERE user_id = 112;
UPDATE sys_user SET user_name = CONVERT(0xE8AEB8E5B3B0 USING utf8mb4) WHERE user_id = 113;
UPDATE sys_user SET user_name = CONVERT(0xE98293E6958F USING utf8mb4) WHERE user_id = 114;
UPDATE sys_user SET user_name = CONVERT(0xE8B0A2E5869B USING utf8mb4) WHERE user_id = 115;
UPDATE sys_user SET user_name = CONVERT(0xE5AE8BE6B481 USING utf8mb4) WHERE user_id = 116;
UPDATE sys_user SET user_name = CONVERT(0xE59490E7A38A USING utf8mb4) WHERE user_id = 117;
UPDATE sys_user SET user_name = CONVERT(0xE586AFE580A9 USING utf8mb4) WHERE user_id = 118;
UPDATE sys_user SET user_name = CONVERT(0xE99FA9E8B685 USING utf8mb4) WHERE user_id = 119;
UPDATE sys_user SET user_name = CONVERT(0xE69BB9E99D99 USING utf8mb4) WHERE user_id = 120;
UPDATE sys_user SET user_name = CONVERT(0xE6BD98E4BC9F USING utf8mb4) WHERE user_id = 121;
UPDATE sys_user SET user_name = CONVERT(0xE8A281E5A99C USING utf8mb4) WHERE user_id = 122;
UPDATE sys_user SET user_name = CONVERT(0xE891A3E587AF USING utf8mb4) WHERE user_id = 123;
UPDATE sys_user SET user_name = CONVERT(0xE4BD99E5A89C USING utf8mb4) WHERE user_id = 124;
UPDATE sys_user SET user_name = CONVERT(0xE88B8FE5BCBA USING utf8mb4) WHERE user_id = 125;
UPDATE sys_user SET user_name = CONVERT(0xE59095E5AA9B USING utf8mb4) WHERE user_id = 126;
UPDATE sys_user SET user_name = CONVERT(0xE7A88BE6B5A9 USING utf8mb4) WHERE user_id = 127;
UPDATE sys_user SET user_name = CONVERT(0xE9AD8FE79290 USING utf8mb4) WHERE user_id = 128;
UPDATE sys_user SET user_name = CONVERT(0xE8928BE58D9A USING utf8mb4) WHERE user_id = 129;
UPDATE sys_user SET user_name = CONVERT(0xE6B288E790B3 USING utf8mb4) WHERE user_id = 130;
UPDATE sys_user SET user_name = CONVERT(0xE5BDADE6B69B USING utf8mb4) WHERE user_id = 131;
UPDATE sys_user SET user_name = CONVERT(0xE5AD94E99BAA USING utf8mb4) WHERE user_id = 132;
UPDATE sys_user SET user_name = CONVERT(0xE6AEB5E69DB0 USING utf8mb4) WHERE user_id = 133;
UPDATE sys_user SET user_name = CONVERT(0xE99BB7E88AB3 USING utf8mb4) WHERE user_id = 134;
UPDATE sys_user SET user_name = CONVERT(0xE4BEAFE581A5 USING utf8mb4) WHERE user_id = 135;
UPDATE sys_user SET user_name = CONVERT(0xE9BE99E6A285 USING utf8mb4) WHERE user_id = 136;
UPDATE sys_user SET user_name = CONVERT(0xE799BDE699A8 USING utf8mb4) WHERE user_id = 137;
UPDATE sys_user SET user_name = CONVERT(0xE9BE9AE4BDB3 USING utf8mb4) WHERE user_id = 138;
UPDATE sys_user SET user_name = CONVERT(0xE9BB8EE9B98F USING utf8mb4) WHERE user_id = 139;
UPDATE sys_user SET user_name = CONVERT(0xE5AD9FE5A797 USING utf8mb4) WHERE user_id = 140;
-- <<< END FILE: sql/fix_user_names.sql

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
