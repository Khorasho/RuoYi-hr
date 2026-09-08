<h1 align="center">RuoYi-HR</h1>

<h4 align="center">基于 RuoYi v4.8.3 二次开发的人力资源考勤管理系统</h4>

## 项目定位

本项目是一套面向中小团队的人力资源（HR）管理系统，基于开源快速开发框架 RuoYi v4.8.3（Spring Boot 4.x + Shiro + Thymeleaf + MyBatis）二次开发而来。在保留 RuoYi 完整后台管理底座（用户、角色、部门、菜单、字典、日志、定时任务、代码生成等）的基础上，扩展了完整的 **HR 考勤业务模块**，覆盖员工档案、班次定义、月度排班、考勤数据处理与考勤报表的全流程。

系统采用经典的单体多模块架构，前端页面开箱即用，无需单独构建前端工程，适合直接部署到企业内网使用。

## 免费使用说明

本项目基于 MIT 许可证开源，**个人及企业均可免费使用、修改和二次分发**，无需支付任何费用。使用时请遵守下文 [许可证](#许可证) 中的 MIT 条款（保留版权声明与许可声明）。

## 在线体验

- 演示地址：http://ruoyi.vip
- 默认账号：`admin` / `admin123`

> 演示地址为上游框架的在线环境，仅用于体验基础后台功能；本项目的 HR 考勤模块请在本地部署后使用。

## 环境要求

| 依赖 | 版本要求 | 说明 |
| :--- | :--- | :--- |
| JDK | 17 及以上 | `pom.xml` 中 `java.version=17` |
| Maven | 3.6 及以上 | 用于编译打包 |
| MySQL | 5.7 / 8.0 | 字符集建议 `utf8mb4` |
| 浏览器 | Chrome / Edge 等现代浏览器 | — |

## 获取项目

将项目克隆到本地任意目录（下文以 `D:\ruoyi\RuoYi-hr` 为例，替换为你自己的路径即可）：

```bash
git clone <本仓库地址> D:\ruoyi\RuoYi-hr
cd D:\ruoyi\RuoYi-hr
```

项目为 Maven 多模块结构：

```
RuoYi-hr
├── ruoyi-admin      // 后台服务入口（Web 启动模块，含 HR 业务控制器）
├── ruoyi-framework  // 框架核心（Shiro 安全、数据源、AOP 等）
├── ruoyi-system     // 系统模块（用户/角色/菜单等）+ HR 业务逻辑
├── ruoyi-quartz     // 定时任务模块
├── ruoyi-generator  // 代码生成模块
├── ruoyi-common     // 通用工具模块
└── sql              // 数据库初始化与升级脚本
```

## 数据库初始化

1. 创建数据库（库名需与配置文件一致，默认为 `hr_db`）：

```sql
CREATE DATABASE hr_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

2. 按**以下顺序**依次导入 `sql/` 目录下的脚本：

| 顺序 | 脚本 | 说明 |
| :--- | :--- | :--- |
| 1 | `sql/ry_20260319.sql` | RuoYi 基础表结构及初始数据（含 admin 账号） |
| 2 | `sql/quartz.sql` | 定时任务模块所需表 |
| 3 | `sql/hr_init.sql` | HR 模块初始化（员工、班次、排班、考勤表 + 菜单权限） |
| 4 | `sql/hr_v2_schedule_attendance.sql` | 排班与考勤增强 |
| 5 | `sql/hr_v3_attendance_rule_demo.sql` | 考勤规则及演示数据 |
| 6 | `sql/hr_v4_attendance_record.sql` | 考勤打卡记录表 |
| 7 | `sql/hr_v5_shift_segment.sql` | 班次时段拆分 |
| 8 | `sql/hr_v6_attendance_result_segment.sql` | 考勤结果时段拆分 |
| 9 | `sql/hr_v7_dict.sql` | HR 相关字典数据 |
| 10 | `sql/hr_v8_rotation_annual.sql` | 轮班与年度排班支持 |
| 11 | `sql/hr_v9_text_cleanup.sql` | 文案清理 |

命令行导入示例（在项目根目录执行）：

```bash
mysql -uroot -p hr_db < sql/ry_20260319.sql
mysql -uroot -p hr_db < sql/quartz.sql
mysql -uroot -p hr_db < sql/hr_init.sql
mysql -uroot -p hr_db < sql/hr_v2_schedule_attendance.sql
mysql -uroot -p hr_db < sql/hr_v3_attendance_rule_demo.sql
mysql -uroot -p hr_db < sql/hr_v4_attendance_record.sql
mysql -uroot -p hr_db < sql/hr_v5_shift_segment.sql
mysql -uroot -p hr_db < sql/hr_v6_attendance_result_segment.sql
mysql -uroot -p hr_db < sql/hr_v7_dict.sql
mysql -uroot -p hr_db < sql/hr_v8_rotation_annual.sql
mysql -uroot -p hr_db < sql/hr_v9_text_cleanup.sql
```

## 配置修改

配置文件位于 `ruoyi-admin/src/main/resources/`，按需修改以下两处：

**1. 数据库连接** — `application-druid.yml`

```yaml
spring:
    datasource:
        druid:
            master:
                # 修改为你的 MySQL 地址与库名
                url: jdbc:mysql://localhost:3306/hr_db?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
                username: root        # 修改为你的数据库用户名
                password: root        # 修改为你的数据库密码
```

**2. 服务端口与文件上传路径** — `application.yml`

```yaml
ruoyi:
  # 文件上传保存路径，Windows 示例：D:/ruoyi/uploadPath，Linux 示例：/home/ruoyi/uploadPath
  profile: D:/ruoyi/uploadPath

server:
  # 服务端口，默认 80，可改为 8080 等未占用端口
  port: 80
```

> 当前配置中验证码默认关闭（`shiro.user.captchaEnabled: false`），如需开启验证码登录，将其改为 `true` 即可。

## 编译与启动

### 方式一：IDE 中运行（开发调试）

1. 使用 IDEA / Eclipse 导入项目根目录的 `pom.xml`，等待 Maven 下载依赖；
2. 运行主启动类 `ruoyi-admin/src/main/java/com/ruoyi/RuoYiApplication.java` 的 `main` 方法。

### 方式二：命令行打包运行（生产部署）

在项目根目录执行：

```bash
# 编译打包（跳过测试）
mvn clean package -DskipTests
```

打包产物位于 `ruoyi-admin/target/ruoyi-admin.jar`，启动：

```bash
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

### 方式三：使用自带脚本（Windows）

项目根目录提供了 `ry.bat`，可将打包好的 `ruoyi-admin.jar` 放到根目录后，通过菜单式交互完成启动、关闭、重启与状态查看；Linux 环境使用根目录的 `ry.sh`。

## 访问系统

启动成功后，浏览器访问：

- 本机部署：`http://localhost`（端口为 80 时）或 `http://localhost:8080`（按 `server.port` 配置）
- 默认账号：`admin` / `admin123`

登录后可在左侧菜单看到 **HR管理** 一级菜单，包含：

| 菜单 | 功能说明 |
| :--- | :--- |
| 组织员工 | 员工档案维护（工号、岗位类型、入职日期、在职状态、默认班次组等），支持批量导入导出 |
| 班次管理 | 定义班次（上下班时间、时段拆分、夏季延时、每周上班掩码等） |
| 排班管理 | 按人员/部门按月排班，支持轮班与年度排班 |
| 考勤处理 | 考勤打卡记录处理、考勤结果计算与重算、异常记录管理 |
| 考勤报表 | 按部门/人员维度的考勤统计报表与导出 |
| 规则配置 | 考勤规则参数配置（迟到、早退、缺勤判定等） |

## 许可证

本项目基于 **MIT License** 发布（详见根目录 `LICENSE` 文件）：

- 任何个人或组织均可**免费**获得本软件副本，并不受限制地使用、复制、修改、合并、出版、分发、再许可及销售软件副本；
- 唯一条件是在软件的所有副本或主要部分中**保留原始版权声明与许可声明**；
- 软件按“现状”提供，不附带任何明示或默示的担保，作者或版权持有人不对因软件产生的任何索赔、损害或其他责任负责。

原始版权信息：`Copyright (c) 2018 RuoYi`
