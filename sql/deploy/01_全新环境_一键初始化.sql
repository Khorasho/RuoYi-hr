-- =========================================================
-- HR系统全新环境一键初始化（含基础库+HR模块+演示数据）
-- 生成时间: 2026-05-22 03:11:38
-- =========================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- >>> BEGIN FILE: sql/ry_20260319.sql
-- ----------------------------
-- 1、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id           bigint(20)      not null auto_increment    comment '部门id',
  parent_id         bigint(20)      default 0                  comment '父部门id',
  ancestors         varchar(50)     default ''                 comment '祖级列表',
  dept_name         varchar(30)     default ''                 comment '部门名称',
  order_num         int(4)          default 0                  comment '显示顺序',
  leader            varchar(20)     default null               comment '负责人',
  phone             varchar(11)     default null               comment '联系电话',
  email             varchar(50)     default null               comment '邮箱',
  status            char(1)         default '0'                comment '部门状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (dept_id)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
insert into sys_dept values(100,  0,   '0',          '若依科技',   0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(101,  100, '0,100',      '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(102,  100, '0,100',      '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(103,  101, '0,100,101',  '研发部门',   1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(104,  101, '0,100,101',  '市场部门',   2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(105,  101, '0,100,101',  '测试部门',   3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(106,  101, '0,100,101',  '财务部门',   4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(107,  101, '0,100,101',  '运维部门',   5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(108,  102, '0,100,102',  '市场部门',   1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(109,  102, '0,100,102',  '财务部门',   2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);


-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint(20)      not null auto_increment    comment '用户ID',
  dept_id           bigint(20)      default null               comment '部门ID',
  login_name        varchar(30)     not null                   comment '登录账号',
  user_name         varchar(30)     default ''                 comment '用户昵称',
  user_type         varchar(2)      default '00'               comment '用户类型（00系统用户 01注册用户）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像路径',
  password          varchar(50)     default ''                 comment '密码',
  salt              varchar(20)     default ''                 comment '盐加密',
  status            char(1)         default '0'                comment '账号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(128)    default ''                 comment '最后登录IP',
  login_date        datetime                                   comment '最后登录时间',
  pwd_update_date   datetime                                   comment '密码最后更新时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (user_id)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1,  103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '29c67a30398638269fe600f73a054934', '111111', '0', '0', '127.0.0.1', null, null, 'admin', sysdate(), '', null, '管理员');
insert into sys_user values(2,  105, 'ry',    '若依', '00', 'ry@qq.com',  '15666666666', '1', '', '8e6d98b90472783cc73c17047ddccf36', '222222', '0', '0', '127.0.0.1', null, null, 'admin', sysdate(), '', null, '测试员');


-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
  post_id       bigint(20)      not null auto_increment    comment '岗位ID',
  post_code     varchar(64)     not null                   comment '岗位编码',
  post_name     varchar(50)     not null                   comment '岗位名称',
  post_sort     int(4)          not null                   comment '显示顺序',
  status        char(1)         not null                   comment '状态（0正常 1停用）',
  create_by     varchar(64)     default ''                 comment '创建者',
  create_time   datetime                                   comment '创建时间',
  update_by     varchar(64)     default ''			       comment '更新者',
  update_time   datetime                                   comment '更新时间',
  remark        varchar(500)    default null               comment '备注',
  primary key (post_id)
) engine=innodb comment = '岗位信息表';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
insert into sys_post values(1, 'ceo',  '董事长',    1, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(2, 'se',   '项目经理',  2, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(3, 'hr',   '人力资源',  3, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(4, 'user', '普通员工',  4, '0', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id           bigint(20)      not null auto_increment    comment '角色ID',
  role_name         varchar(30)     not null                   comment '角色名称',
  role_key          varchar(100)    not null                   comment '角色权限字符串',
  role_sort         int(4)          not null                   comment '显示顺序',
  data_scope        char(1)         default '1'                comment '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  status            char(1)         not null                   comment '角色状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', '超级管理员', 'admin',  1, 1, '0', '0', 'admin', sysdate(), '', null, '超级管理员');
insert into sys_role values('2', '普通角色',   'common', 2, 2, '0', '0', 'admin', sysdate(), '', null, '普通角色');


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  url               varchar(200)    default '#'                comment '请求地址',
  target            varchar(20)     default ''                 comment '打开方式（menuItem页签 menuBlank新窗口）',
  menu_type         char(1)         default ''                 comment '菜单类型（M目录 C菜单 F按钮）',
  visible           char(1)         default 0                  comment '菜单状态（0显示 1隐藏）',
  is_refresh        char(1)         default 1                  comment '是否刷新（0刷新 1不刷新）',
  perms             varchar(100)    default null               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', '#',                '',          'M', '0', '1', '', 'fa fa-gear',           'admin', sysdate(), '', null, '系统管理目录');
insert into sys_menu values('2', '系统监控', '0', '2', '#',                '',          'M', '0', '1', '', 'fa fa-video-camera',   'admin', sysdate(), '', null, '系统监控目录');
insert into sys_menu values('3', '系统工具', '0', '3', '#',                '',          'M', '0', '1', '', 'fa fa-bars',           'admin', sysdate(), '', null, '系统工具目录');
insert into sys_menu values('4', '若依官网', '0', '4', 'http://ruoyi.vip', 'menuBlank', 'C', '0', '1', '', 'fa fa-location-arrow', 'admin', sysdate(), '', null, '若依官网地址');
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1', '1', '/system/user',          '', 'C', '0', '1', 'system:user:view',         'fa fa-user-o',          'admin', sysdate(), '', null, '用户管理菜单');
insert into sys_menu values('101',  '角色管理', '1', '2', '/system/role',          '', 'C', '0', '1', 'system:role:view',         'fa fa-user-secret',     'admin', sysdate(), '', null, '角色管理菜单');
insert into sys_menu values('102',  '菜单管理', '1', '3', '/system/menu',          '', 'C', '0', '1', 'system:menu:view',         'fa fa-th-list',         'admin', sysdate(), '', null, '菜单管理菜单');
insert into sys_menu values('103',  '部门管理', '1', '4', '/system/dept',          '', 'C', '0', '1', 'system:dept:view',         'fa fa-outdent',         'admin', sysdate(), '', null, '部门管理菜单');
insert into sys_menu values('104',  '岗位管理', '1', '5', '/system/post',          '', 'C', '0', '1', 'system:post:view',         'fa fa-address-card-o',  'admin', sysdate(), '', null, '岗位管理菜单');
insert into sys_menu values('105',  '字典管理', '1', '6', '/system/dict',          '', 'C', '0', '1', 'system:dict:view',         'fa fa-bookmark-o',      'admin', sysdate(), '', null, '字典管理菜单');
insert into sys_menu values('106',  '参数设置', '1', '7', '/system/config',        '', 'C', '0', '1', 'system:config:view',       'fa fa-sun-o',           'admin', sysdate(), '', null, '参数设置菜单');
insert into sys_menu values('107',  '通知公告', '1', '8', '/system/notice',        '', 'C', '0', '1', 'system:notice:view',       'fa fa-bullhorn',        'admin', sysdate(), '', null, '通知公告菜单');
insert into sys_menu values('108',  '日志管理', '1', '9', '#',                     '', 'M', '0', '1', '',                         'fa fa-pencil-square-o', 'admin', sysdate(), '', null, '日志管理菜单');
insert into sys_menu values('109',  '在线用户', '2', '1', '/monitor/online',       '', 'C', '0', '1', 'monitor:online:view',      'fa fa-user-circle',     'admin', sysdate(), '', null, '在线用户菜单');
insert into sys_menu values('110',  '定时任务', '2', '2', '/monitor/job',          '', 'C', '0', '1', 'monitor:job:view',         'fa fa-tasks',           'admin', sysdate(), '', null, '定时任务菜单');
insert into sys_menu values('111',  '数据监控', '2', '3', '/monitor/data',         '', 'C', '0', '1', 'monitor:data:view',        'fa fa-bug',             'admin', sysdate(), '', null, '数据监控菜单');
insert into sys_menu values('112',  '服务监控', '2', '4', '/monitor/server',       '', 'C', '0', '1', 'monitor:server:view',      'fa fa-server',          'admin', sysdate(), '', null, '服务监控菜单');
insert into sys_menu values('113',  '缓存监控', '2', '5', '/monitor/cache',        '', 'C', '0', '1', 'monitor:cache:view',       'fa fa-cube',            'admin', sysdate(), '', null, '缓存监控菜单');
insert into sys_menu values('114',  '表单构建', '3', '1', '/tool/build',           '', 'C', '0', '1', 'tool:build:view',          'fa fa-wpforms',         'admin', sysdate(), '', null, '表单构建菜单');
insert into sys_menu values('115',  '代码生成', '3', '2', '/tool/gen',             '', 'C', '0', '1', 'tool:gen:view',            'fa fa-code',            'admin', sysdate(), '', null, '代码生成菜单');
insert into sys_menu values('116',  '系统接口', '3', '3', '/tool/swagger',         '', 'C', '0', '1', 'tool:swagger:view',        'fa fa-gg',              'admin', sysdate(), '', null, '系统接口菜单');
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', '/monitor/operlog',    '', 'C', '0', '1', 'monitor:operlog:view',     'fa fa-address-book',    'admin', sysdate(), '', null, '操作日志菜单');
insert into sys_menu values('501',  '登录日志', '108', '2', '/monitor/logininfor', '', 'C', '0', '1', 'monitor:logininfor:view',  'fa fa-file-image-o',    'admin', sysdate(), '', null, '登录日志菜单');
-- 用户管理按钮
insert into sys_menu values('1000', '用户查询', '100', '1',  '#', '',  'F', '0', '1', 'system:user:list',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1001', '用户新增', '100', '2',  '#', '',  'F', '0', '1', 'system:user:add',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1002', '用户修改', '100', '3',  '#', '',  'F', '0', '1', 'system:user:edit',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1003', '用户删除', '100', '4',  '#', '',  'F', '0', '1', 'system:user:remove',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1004', '用户导出', '100', '5',  '#', '',  'F', '0', '1', 'system:user:export',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1005', '用户导入', '100', '6',  '#', '',  'F', '0', '1', 'system:user:import',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1006', '重置密码', '100', '7',  '#', '',  'F', '0', '1', 'system:user:resetPwd',    '#', 'admin', sysdate(), '', null, '');
-- 角色管理按钮
insert into sys_menu values('1007', '角色查询', '101', '1',  '#', '',  'F', '0', '1', 'system:role:list',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1008', '角色新增', '101', '2',  '#', '',  'F', '0', '1', 'system:role:add',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1009', '角色修改', '101', '3',  '#', '',  'F', '0', '1', 'system:role:edit',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1010', '角色删除', '101', '4',  '#', '',  'F', '0', '1', 'system:role:remove',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1011', '角色导出', '101', '5',  '#', '',  'F', '0', '1', 'system:role:export',      '#', 'admin', sysdate(), '', null, '');
-- 菜单管理按钮
insert into sys_menu values('1012', '菜单查询', '102', '1',  '#', '',  'F', '0', '1', 'system:menu:list',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1013', '菜单新增', '102', '2',  '#', '',  'F', '0', '1', 'system:menu:add',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1014', '菜单修改', '102', '3',  '#', '',  'F', '0', '1', 'system:menu:edit',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1015', '菜单删除', '102', '4',  '#', '',  'F', '0', '1', 'system:menu:remove',      '#', 'admin', sysdate(), '', null, '');
-- 部门管理按钮
insert into sys_menu values('1016', '部门查询', '103', '1',  '#', '',  'F', '0', '1', 'system:dept:list',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1017', '部门新增', '103', '2',  '#', '',  'F', '0', '1', 'system:dept:add',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1018', '部门修改', '103', '3',  '#', '',  'F', '0', '1', 'system:dept:edit',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1019', '部门删除', '103', '4',  '#', '',  'F', '0', '1', 'system:dept:remove',      '#', 'admin', sysdate(), '', null, '');
-- 岗位管理按钮
insert into sys_menu values('1020', '岗位查询', '104', '1',  '#', '',  'F', '0', '1', 'system:post:list',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1021', '岗位新增', '104', '2',  '#', '',  'F', '0', '1', 'system:post:add',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1022', '岗位修改', '104', '3',  '#', '',  'F', '0', '1', 'system:post:edit',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1023', '岗位删除', '104', '4',  '#', '',  'F', '0', '1', 'system:post:remove',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1024', '岗位导出', '104', '5',  '#', '',  'F', '0', '1', 'system:post:export',      '#', 'admin', sysdate(), '', null, '');
-- 字典管理按钮
insert into sys_menu values('1025', '字典查询', '105', '1',  '#', '',  'F', '0', '1', 'system:dict:list',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1026', '字典新增', '105', '2',  '#', '',  'F', '0', '1', 'system:dict:add',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1027', '字典修改', '105', '3',  '#', '',  'F', '0', '1', 'system:dict:edit',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1028', '字典删除', '105', '4',  '#', '',  'F', '0', '1', 'system:dict:remove',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1029', '字典导出', '105', '5',  '#', '',  'F', '0', '1', 'system:dict:export',      '#', 'admin', sysdate(), '', null, '');
-- 参数设置按钮
insert into sys_menu values('1030', '参数查询', '106', '1',  '#', '',  'F', '0', '1', 'system:config:list',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1031', '参数新增', '106', '2',  '#', '',  'F', '0', '1', 'system:config:add',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1032', '参数修改', '106', '3',  '#', '',  'F', '0', '1', 'system:config:edit',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1033', '参数删除', '106', '4',  '#', '',  'F', '0', '1', 'system:config:remove',    '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1034', '参数导出', '106', '5',  '#', '',  'F', '0', '1', 'system:config:export',    '#', 'admin', sysdate(), '', null, '');
-- 通知公告按钮
insert into sys_menu values('1035', '公告查询', '107', '1',  '#', '',  'F', '0', '1', 'system:notice:list',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1036', '公告新增', '107', '2',  '#', '',  'F', '0', '1', 'system:notice:add',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1037', '公告修改', '107', '3',  '#', '',  'F', '0', '1', 'system:notice:edit',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1038', '公告删除', '107', '4',  '#', '',  'F', '0', '1', 'system:notice:remove',    '#', 'admin', sysdate(), '', null, '');
-- 操作日志按钮
insert into sys_menu values('1039', '操作查询', '500', '1',  '#', '',  'F', '0', '1', 'monitor:operlog:list',    '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1040', '操作删除', '500', '2',  '#', '',  'F', '0', '1', 'monitor:operlog:remove',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1041', '详细信息', '500', '3',  '#', '',  'F', '0', '1', 'monitor:operlog:detail',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1042', '日志导出', '500', '4',  '#', '',  'F', '0', '1', 'monitor:operlog:export',  '#', 'admin', sysdate(), '', null, '');
-- 登录日志按钮
insert into sys_menu values('1043', '登录查询', '501', '1',  '#', '',  'F', '0', '1', 'monitor:logininfor:list',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1044', '登录删除', '501', '2',  '#', '',  'F', '0', '1', 'monitor:logininfor:remove',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1045', '日志导出', '501', '3',  '#', '',  'F', '0', '1', 'monitor:logininfor:export',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1046', '账户解锁', '501', '4',  '#', '',  'F', '0', '1', 'monitor:logininfor:unlock',       '#', 'admin', sysdate(), '', null, '');
-- 在线用户按钮
insert into sys_menu values('1047', '在线查询', '109', '1',  '#', '',  'F', '0', '1', 'monitor:online:list',             '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1048', '批量强退', '109', '2',  '#', '',  'F', '0', '1', 'monitor:online:batchForceLogout', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1049', '单条强退', '109', '3',  '#', '',  'F', '0', '1', 'monitor:online:forceLogout',      '#', 'admin', sysdate(), '', null, '');
-- 定时任务按钮
insert into sys_menu values('1050', '任务查询', '110', '1',  '#', '',  'F', '0', '1', 'monitor:job:list',                '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1051', '任务新增', '110', '2',  '#', '',  'F', '0', '1', 'monitor:job:add',                 '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1052', '任务修改', '110', '3',  '#', '',  'F', '0', '1', 'monitor:job:edit',                '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1053', '任务删除', '110', '4',  '#', '',  'F', '0', '1', 'monitor:job:remove',              '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1054', '状态修改', '110', '5',  '#', '',  'F', '0', '1', 'monitor:job:changeStatus',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1055', '任务详细', '110', '6',  '#', '',  'F', '0', '1', 'monitor:job:detail',              '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1056', '任务导出', '110', '7',  '#', '',  'F', '0', '1', 'monitor:job:export',              '#', 'admin', sysdate(), '', null, '');
-- 代码生成按钮
insert into sys_menu values('1057', '生成查询', '115', '1',  '#', '',  'F', '0', '1', 'tool:gen:list',     '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1058', '生成修改', '115', '2',  '#', '',  'F', '0', '1', 'tool:gen:edit',     '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1059', '生成删除', '115', '3',  '#', '',  'F', '0', '1', 'tool:gen:remove',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1060', '预览代码', '115', '4',  '#', '',  'F', '0', '1', 'tool:gen:preview',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1061', '生成代码', '115', '5',  '#', '',  'F', '0', '1', 'tool:gen:code',     '#', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
insert into sys_role_menu values ('2', '1');
insert into sys_role_menu values ('2', '2');
insert into sys_role_menu values ('2', '3');
insert into sys_role_menu values ('2', '4');
insert into sys_role_menu values ('2', '100');
insert into sys_role_menu values ('2', '101');
insert into sys_role_menu values ('2', '102');
insert into sys_role_menu values ('2', '103');
insert into sys_role_menu values ('2', '104');
insert into sys_role_menu values ('2', '105');
insert into sys_role_menu values ('2', '106');
insert into sys_role_menu values ('2', '107');
insert into sys_role_menu values ('2', '108');
insert into sys_role_menu values ('2', '109');
insert into sys_role_menu values ('2', '110');
insert into sys_role_menu values ('2', '111');
insert into sys_role_menu values ('2', '112');
insert into sys_role_menu values ('2', '113');
insert into sys_role_menu values ('2', '114');
insert into sys_role_menu values ('2', '115');
insert into sys_role_menu values ('2', '116');
insert into sys_role_menu values ('2', '500');
insert into sys_role_menu values ('2', '501');
insert into sys_role_menu values ('2', '1000');
insert into sys_role_menu values ('2', '1001');
insert into sys_role_menu values ('2', '1002');
insert into sys_role_menu values ('2', '1003');
insert into sys_role_menu values ('2', '1004');
insert into sys_role_menu values ('2', '1005');
insert into sys_role_menu values ('2', '1006');
insert into sys_role_menu values ('2', '1007');
insert into sys_role_menu values ('2', '1008');
insert into sys_role_menu values ('2', '1009');
insert into sys_role_menu values ('2', '1010');
insert into sys_role_menu values ('2', '1011');
insert into sys_role_menu values ('2', '1012');
insert into sys_role_menu values ('2', '1013');
insert into sys_role_menu values ('2', '1014');
insert into sys_role_menu values ('2', '1015');
insert into sys_role_menu values ('2', '1016');
insert into sys_role_menu values ('2', '1017');
insert into sys_role_menu values ('2', '1018');
insert into sys_role_menu values ('2', '1019');
insert into sys_role_menu values ('2', '1020');
insert into sys_role_menu values ('2', '1021');
insert into sys_role_menu values ('2', '1022');
insert into sys_role_menu values ('2', '1023');
insert into sys_role_menu values ('2', '1024');
insert into sys_role_menu values ('2', '1025');
insert into sys_role_menu values ('2', '1026');
insert into sys_role_menu values ('2', '1027');
insert into sys_role_menu values ('2', '1028');
insert into sys_role_menu values ('2', '1029');
insert into sys_role_menu values ('2', '1030');
insert into sys_role_menu values ('2', '1031');
insert into sys_role_menu values ('2', '1032');
insert into sys_role_menu values ('2', '1033');
insert into sys_role_menu values ('2', '1034');
insert into sys_role_menu values ('2', '1035');
insert into sys_role_menu values ('2', '1036');
insert into sys_role_menu values ('2', '1037');
insert into sys_role_menu values ('2', '1038');
insert into sys_role_menu values ('2', '1039');
insert into sys_role_menu values ('2', '1040');
insert into sys_role_menu values ('2', '1041');
insert into sys_role_menu values ('2', '1042');
insert into sys_role_menu values ('2', '1043');
insert into sys_role_menu values ('2', '1044');
insert into sys_role_menu values ('2', '1045');
insert into sys_role_menu values ('2', '1046');
insert into sys_role_menu values ('2', '1047');
insert into sys_role_menu values ('2', '1048');
insert into sys_role_menu values ('2', '1049');
insert into sys_role_menu values ('2', '1050');
insert into sys_role_menu values ('2', '1051');
insert into sys_role_menu values ('2', '1052');
insert into sys_role_menu values ('2', '1053');
insert into sys_role_menu values ('2', '1054');
insert into sys_role_menu values ('2', '1055');
insert into sys_role_menu values ('2', '1056');
insert into sys_role_menu values ('2', '1057');
insert into sys_role_menu values ('2', '1058');
insert into sys_role_menu values ('2', '1059');
insert into sys_role_menu values ('2', '1060');
insert into sys_role_menu values ('2', '1061');

-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
drop table if exists sys_role_dept;
create table sys_role_dept (
  role_id   bigint(20) not null comment '角色ID',
  dept_id   bigint(20) not null comment '部门ID',
  primary key(role_id, dept_id)
) engine=innodb comment = '角色和部门关联表';

-- ----------------------------
-- 初始化-角色和部门关联表数据
-- ----------------------------
insert into sys_role_dept values ('2', '100');
insert into sys_role_dept values ('2', '101');
insert into sys_role_dept values ('2', '105');

-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
  user_id   bigint(20) not null comment '用户ID',
  post_id   bigint(20) not null comment '岗位ID',
  primary key (user_id, post_id)
) engine=innodb comment = '用户与岗位关联表';

-- ----------------------------
-- 初始化-用户与岗位关联表数据
-- ----------------------------
insert into sys_user_post values ('1', '1');
insert into sys_user_post values ('2', '2');


-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id           bigint(20)      not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     int(2)          default 0                  comment '业务类型（0其它 1新增 2修改 3删除）',
  method            varchar(200)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  operator_type     int(1)          default 0                  comment '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         varchar(50)     default ''                 comment '操作人员',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(255)    default ''                 comment '请求URL',
  oper_ip           varchar(128)    default ''                 comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            int(1)          default 0                  comment '操作状态（0正常 1异常）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  cost_time         bigint(20)      default 0                  comment '消耗时间',
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
) engine=innodb auto_increment=100 comment = '操作日志记录';


-- ----------------------------
-- 11、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint(20)      not null auto_increment    comment '字典主键',
  dict_name        varchar(100)    default ''                 comment '字典名称',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_id),
  unique (dict_type)
) engine=innodb auto_increment=100 comment = '字典类型表';

insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', sysdate(), '', null, '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', sysdate(), '', null, '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', sysdate(), '', null, '系统开关列表');
insert into sys_dict_type values(4,  '任务状态', 'sys_job_status',      '0', 'admin', sysdate(), '', null, '任务状态列表');
insert into sys_dict_type values(5,  '任务分组', 'sys_job_group',       '0', 'admin', sysdate(), '', null, '任务分组列表');
insert into sys_dict_type values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', sysdate(), '', null, '系统是否列表');
insert into sys_dict_type values(7,  '通知类型', 'sys_notice_type',     '0', 'admin', sysdate(), '', null, '通知类型列表');
insert into sys_dict_type values(8,  '通知状态', 'sys_notice_status',   '0', 'admin', sysdate(), '', null, '通知状态列表');
insert into sys_dict_type values(9,  '操作类型', 'sys_oper_type',       '0', 'admin', sysdate(), '', null, '操作类型列表');
insert into sys_dict_type values(10, '系统状态', 'sys_common_status',   '0', 'admin', sysdate(), '', null, '登录状态列表');


-- ----------------------------
-- 12、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint(20)      not null auto_increment    comment '字典编码',
  dict_sort        int(4)          default 0                  comment '字典排序',
  dict_label       varchar(100)    default ''                 comment '字典标签',
  dict_value       varchar(100)    default ''                 comment '字典键值',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  css_class        varchar(100)    default null               comment '样式属性（其他样式扩展）',
  list_class       varchar(100)    default null               comment '表格回显样式',
  is_default       char(1)         default 'N'                comment '是否默认（Y是 N否）',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_code)
) engine=innodb auto_increment=100 comment = '字典数据表';

insert into sys_dict_data values(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', sysdate(), '', null, '性别男');
insert into sys_dict_data values(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别女');
insert into sys_dict_data values(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别未知');
insert into sys_dict_data values(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '显示菜单');
insert into sys_dict_data values(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '隐藏菜单');
insert into sys_dict_data values(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', sysdate(), '', null, '默认分组');
insert into sys_dict_data values(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', sysdate(), '', null, '系统分组');
insert into sys_dict_data values(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '系统默认是');
insert into sys_dict_data values(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '系统默认否');
insert into sys_dict_data values(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', sysdate(), '', null, '通知');
insert into sys_dict_data values(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', sysdate(), '', null, '公告');
insert into sys_dict_data values(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '关闭状态');
insert into sys_dict_data values(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '其他操作');
insert into sys_dict_data values(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '新增操作');
insert into sys_dict_data values(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '修改操作');
insert into sys_dict_data values(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '删除操作');
insert into sys_dict_data values(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '授权操作');
insert into sys_dict_data values(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导出操作');
insert into sys_dict_data values(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导入操作');
insert into sys_dict_data values(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '强退操作');
insert into sys_dict_data values(26, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '生成操作');
insert into sys_dict_data values(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '清空操作');
insert into sys_dict_data values(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');


-- ----------------------------
-- 13、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int(5)          not null auto_increment    comment '参数主键',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  config_type       char(1)         default 'N'                comment '系统内置（Y是 N否）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = '参数配置表';

insert into sys_config values(1,  '主框架页-默认皮肤样式名称',     'sys.index.skinName',               'skin-blue',     'Y', 'admin', sysdate(), '', null, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
insert into sys_config values(2,  '用户管理-账号初始密码',         'sys.user.initPassword',            '123456',        'Y', 'admin', sysdate(), '', null, '初始化密码 123456');
insert into sys_config values(3,  '主框架页-侧边栏主题',           'sys.index.sideTheme',              'theme-dark',    'Y', 'admin', sysdate(), '', null, '深黑主题theme-dark，浅色主题theme-light，深蓝主题theme-blue');
insert into sys_config values(4,  '账号自助-是否开启用户注册功能', 'sys.account.registerUser',         'false',         'Y', 'admin', sysdate(), '', null, '是否开启注册用户功能（true开启，false关闭）');
insert into sys_config values(5,  '用户管理-密码字符范围',         'sys.account.chrtype',              '0',             'Y', 'admin', sysdate(), '', null, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
insert into sys_config values(6,  '用户管理-初始密码修改策略',     'sys.account.initPasswordModify',   '1',             'Y', 'admin', sysdate(), '', null, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
insert into sys_config values(7,  '用户管理-账号密码更新周期',     'sys.account.passwordValidateDays', '0',             'Y', 'admin', sysdate(), '', null, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
insert into sys_config values(8,  '主框架页-菜单导航显示风格',     'sys.index.menuStyle',              'default',       'Y', 'admin', sysdate(), '', null, '菜单导航显示风格（default为左侧导航菜单，topnav为顶部导航菜单）');
insert into sys_config values(9,  '主框架页-是否开启页脚',         'sys.index.footer',                 'true',          'Y', 'admin', sysdate(), '', null, '是否开启底部页脚显示（true显示，false隐藏）');
insert into sys_config values(10, '主框架页-是否开启页签',         'sys.index.tagsView',               'true',          'Y', 'admin', sysdate(), '', null, '是否开启菜单多页签显示（true显示，false隐藏）');
insert into sys_config values(11, '用户登录-黑名单列表',           'sys.login.blackIPList',            '',              'Y', 'admin', sysdate(), '', null, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');


-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment '访问ID',
  login_name     varchar(50)    default ''                comment '登录账号',
  ipaddr         varchar(128)   default ''                comment '登录IP地址',
  login_location varchar(255)   default ''                comment '登录地点',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  status         char(1)        default '0'               comment '登录状态（0成功 1失败）',
  msg            varchar(255)   default ''                comment '提示消息',
  login_time     datetime                                 comment '访问时间',
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
) engine=innodb auto_increment=100 comment = '系统访问记录';


-- ----------------------------
-- 15、在线用户记录
-- ----------------------------
drop table if exists sys_user_online;
create table sys_user_online (
  sessionId         varchar(50)   default ''                comment '用户会话id',
  login_name        varchar(50)   default ''                comment '登录账号',
  dept_name         varchar(50)   default ''                comment '部门名称',
  ipaddr            varchar(128)  default ''                comment '登录IP地址',
  login_location    varchar(255)  default ''                comment '登录地点',
  browser           varchar(50)   default ''                comment '浏览器类型',
  os                varchar(50)   default ''                comment '操作系统',
  status            varchar(10)   default ''                comment '在线状态on_line在线off_line离线',
  start_timestamp   datetime                                comment 'session创建时间',
  last_access_time  datetime                                comment 'session最后访问时间',
  expire_time       int(5)        default 0                 comment '超时时间，单位为分钟',
  session_data      blob          default null              comment '序列化的Session数据，用于服务重启后恢复会话',
  primary key (sessionId)
) engine=innodb comment = '在线用户记录';


-- ----------------------------
-- 16、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '3'                comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  concurrent          char(1)       default '1'                comment '是否并发执行（0允许 1禁止）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

insert into sys_job values(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')',  '0/15 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 17、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              char(1)        default '0'                comment '执行状态（0正常 1失败）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  start_time          datetime                                  comment '执行开始时间',
  end_time            datetime                                  comment '执行结束时间',
  create_time         datetime                                  comment '创建时间',
  primary key (job_log_id)
) engine=innodb comment = '定时任务调度日志表';


-- ----------------------------
-- 18、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int(4)          not null auto_increment    comment '公告ID',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       char(1)         not null                   comment '公告类型（1通知 2公告）',
  notice_content    longblob        default null               comment '公告内容',
  status            char(1)         default '0'                comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(255)    default null               comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = '通知公告表';

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', '温馨提醒：2018-07-01 若依新版本发布啦', '2', '新版本内容', '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('2', '维护通知：2018-07-01 若依系统凌晨维护', '1', '维护内容',   '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('3', '若依开源框架介绍', '1', '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1705030583977401651/5ed5db6a_1151004.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>', '0', 'admin', sysdate(), '', null, '管理员');


-- ----------------------------
-- 19、公告已读记录表
-- ----------------------------
drop table if exists sys_notice_read;
create table sys_notice_read (
  read_id          bigint(20)       not null auto_increment    comment '已读主键',
  notice_id        int(4)           not null                   comment '公告id',
  user_id          bigint(20)       not null                   comment '用户id',
  read_time        datetime         not null                   comment '阅读时间',
  primary key (read_id),
  unique key uk_user_notice (user_id, notice_id)   comment '同一用户同一公告只记录一次'
) engine=innodb auto_increment=1 comment='公告已读记录表';


-- ----------------------------
-- 20、代码生成业务表
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  table_id             bigint(20)      not null auto_increment    comment '编号',
  table_name           varchar(200)    default ''                 comment '表名称',
  table_comment        varchar(500)    default ''                 comment '表描述',
  sub_table_name       varchar(64)     default null               comment '关联子表的表名',
  sub_table_fk_name    varchar(64)     default null               comment '子表关联的外键名',
  class_name           varchar(100)    default ''                 comment '实体类名称',
  tpl_category         varchar(200)    default 'crud'             comment '使用的模板（crud单表操作 tree树表操作 sub主子表操作）',
  package_name         varchar(100)                               comment '生成包路径',
  module_name          varchar(30)                                comment '生成模块名',
  business_name        varchar(30)                                comment '生成业务名',
  function_name        varchar(50)                                comment '生成功能名',
  function_author      varchar(50)                                comment '生成功能作者',
  form_col_num         int(1)          default 1                  comment '表单布局（单列 双列 三列）',
  gen_type             char(1)         default '0'                comment '生成代码方式（0zip压缩包 1自定义路径）',
  gen_path             varchar(200)    default '/'                comment '生成路径（不填默认项目路径）',
  options              varchar(1000)                              comment '其它生成选项',
  create_by            varchar(64)     default ''                 comment '创建者',
  create_time 	       datetime                                   comment '创建时间',
  update_by            varchar(64)     default ''                 comment '更新者',
  update_time          datetime                                   comment '更新时间',
  remark               varchar(500)    default null               comment '备注',
  primary key (table_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表';


-- ----------------------------
-- 21、代码生成业务表字段
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  column_id         bigint(20)      not null auto_increment    comment '编号',
  table_id          bigint(20)                                 comment '归属表编号',
  column_name       varchar(200)                               comment '列名称',
  column_comment    varchar(500)                               comment '列描述',
  column_type       varchar(100)                               comment '列类型',
  java_type         varchar(500)                               comment 'JAVA类型',
  java_field        varchar(200)                               comment 'JAVA字段名',
  is_pk             char(1)                                    comment '是否主键（1是）',
  is_increment      char(1)                                    comment '是否自增（1是）',
  is_required       char(1)                                    comment '是否必填（1是）',
  is_insert         char(1)                                    comment '是否为插入字段（1是）',
  is_edit           char(1)                                    comment '是否编辑字段（1是）',
  is_list           char(1)                                    comment '是否列表字段（1是）',
  is_query          char(1)                                    comment '是否查询字段（1是）',
  query_type        varchar(200)    default 'EQ'               comment '查询方式（等于、不等于、大于、小于、范围）',
  html_type         varchar(200)                               comment '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  dict_type         varchar(200)    default ''                 comment '字典类型',
  sort              int                                        comment '排序',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (column_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表字段';
-- <<< END FILE: sql/ry_20260319.sql

-- >>> BEGIN FILE: sql/quartz.sql
DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null            comment '调度名称',
    job_name             varchar(200)    not null            comment '任务名称',
    job_group            varchar(200)    not null            comment '任务组名',
    description          varchar(250)    null                comment '相关介绍',
    job_class_name       varchar(250)    not null            comment '执行任务类名称',
    is_durable           varchar(1)      not null            comment '是否持久化',
    is_nonconcurrent     varchar(1)      not null            comment '是否并发',
    is_update_data       varchar(1)      not null            comment '是否更新数据',
    requests_recovery    varchar(1)      not null            comment '是否接受恢复执行',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, job_name, job_group)
) engine=innodb comment = '任务详细信息表';

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
create table QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器的名字',
    trigger_group        varchar(200)    not null            comment '触发器所属组的名字',
    job_name             varchar(200)    not null            comment 'qrtz_job_details表job_name的外键',
    job_group            varchar(200)    not null            comment 'qrtz_job_details表job_group的外键',
    description          varchar(250)    null                comment '相关介绍',
    next_fire_time       bigint(13)      null                comment '上一次触发时间（毫秒）',
    prev_fire_time       bigint(13)      null                comment '下一次触发时间（默认为-1表示不触发）',
    priority             integer         null                comment '优先级',
    trigger_state        varchar(16)     not null            comment '触发器状态',
    trigger_type         varchar(8)      not null            comment '触发器的类型',
    start_time           bigint(13)      not null            comment '开始时间',
    end_time             bigint(13)      null                comment '结束时间',
    calendar_name        varchar(200)    null                comment '日程表名称',
    misfire_instr        smallint(2)     null                comment '补偿执行的策略',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
) engine=innodb comment = '触发器详细信息表';

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    repeat_count         bigint(7)       not null            comment '重复的次数统计',
    repeat_interval      bigint(12)      not null            comment '重复的间隔时间',
    times_triggered      bigint(10)      not null            comment '已经触发的次数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '简单触发器的信息表';

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ---------------------------- 
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    cron_expression      varchar(200)    not null            comment 'cron表达式',
    time_zone_id         varchar(80)                         comment '时区',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Cron类型的触发器表';

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ---------------------------- 
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    blob_data            blob            null                comment '存放持久化Trigger对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Blob类型的触发器表';

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ---------------------------- 
create table QRTZ_CALENDARS (
    sched_name           varchar(120)    not null            comment '调度名称',
    calendar_name        varchar(200)    not null            comment '日历名称',
    calendar             blob            not null            comment '存放持久化calendar对象',
    primary key (sched_name, calendar_name)
) engine=innodb comment = '日历信息表';

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ---------------------------- 
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    primary key (sched_name, trigger_group)
) engine=innodb comment = '暂停的触发器表';

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ---------------------------- 
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    entry_id             varchar(95)     not null            comment '调度器实例id',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    instance_name        varchar(200)    not null            comment '调度器实例名',
    fired_time           bigint(13)      not null            comment '触发的时间',
    sched_time           bigint(13)      not null            comment '定时器制定的时间',
    priority             integer         not null            comment '优先级',
    state                varchar(16)     not null            comment '状态',
    job_name             varchar(200)    null                comment '任务名称',
    job_group            varchar(200)    null                comment '任务组名',
    is_nonconcurrent     varchar(1)      null                comment '是否并发',
    requests_recovery    varchar(1)      null                comment '是否接受恢复执行',
    primary key (sched_name, entry_id)
) engine=innodb comment = '已触发的触发器表';

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ---------------------------- 
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null            comment '调度名称',
    instance_name        varchar(200)    not null            comment '实例名称',
    last_checkin_time    bigint(13)      not null            comment '上次检查时间',
    checkin_interval     bigint(13)      not null            comment '检查间隔时间',
    primary key (sched_name, instance_name)
) engine=innodb comment = '调度器状态表';

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ---------------------------- 
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null            comment '调度名称',
    lock_name            varchar(40)     not null            comment '悲观锁名称',
    primary key (sched_name, lock_name)
) engine=innodb comment = '存储的悲观锁信息表';

-- ----------------------------
-- 11、 Quartz集群实现同步机制的行锁表
-- ---------------------------- 
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    str_prop_1           varchar(512)    null                comment 'String类型的trigger的第一个参数',
    str_prop_2           varchar(512)    null                comment 'String类型的trigger的第二个参数',
    str_prop_3           varchar(512)    null                comment 'String类型的trigger的第三个参数',
    int_prop_1           int             null                comment 'int类型的trigger的第一个参数',
    int_prop_2           int             null                comment 'int类型的trigger的第二个参数',
    long_prop_1          bigint          null                comment 'long类型的trigger的第一个参数',
    long_prop_2          bigint          null                comment 'long类型的trigger的第二个参数',
    dec_prop_1           numeric(13,4)   null                comment 'decimal类型的trigger的第一个参数',
    dec_prop_2           numeric(13,4)   null                comment 'decimal类型的trigger的第二个参数',
    bool_prop_1          varchar(1)      null                comment 'Boolean类型的trigger的第一个参数',
    bool_prop_2          varchar(1)      null                comment 'Boolean类型的trigger的第二个参数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '同步机制的行锁表';

commit;
-- <<< END FILE: sql/quartz.sql

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

SET FOREIGN_KEY_CHECKS = 1;
