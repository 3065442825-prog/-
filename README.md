# GIS 全栈开发项目

<div align="center">

**智慧城市学院 — 《GIS工程与开发》课程实验**

[![Vue 3](https://img.shields.io/badge/Vue-3.5-4FC08D?logo=vue.js)](https://vuejs.org/)
[![Vite](https://img.shields.io/badge/Vite-6-646CFF?logo=vite)](https://vite.dev/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.4-6DB33F?logo=springboot)](https://spring.io/projects/spring-boot)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python)](https://www.python.org/)
[![Java](https://img.shields.io/badge/Java-21-ED8B00?logo=openjdk)](https://jdk.java.net/21/)
[![Leaflet](https://img.shields.io/badge/Leaflet-1.9-199900?logo=leaflet)](https://leafletjs.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

> **三层架构**：Vue 3 前端（地图可视化） + Python 数据处理（空间分析） + Java 后端（GIS 服务）

---

## 📦 项目概览

本仓库是一个完整的 GIS 全栈项目模板，覆盖**前端地图交互、空间数据处理、后端服务接口**三个层次，开箱即用。

| 层次 | 技术栈 | 核心职责 |
|------|--------|----------|
| 🖥️ 前端 | Vue 3 + Vite + TypeScript + Leaflet | 地图渲染、交互测量、UI 界面 |
| 🔄 数据处理 | Python 3.12 + GeoPandas + Shapely + GeoPy | 空间数据获取、清洗、分析与转换 |
| ⚙️ 后端 | Java 21 + Spring Boot 3.4 + Maven | GIS 服务 API、空间查询、数据持久化 |
| 🗄️ 数据库 | PostgreSQL + PostGIS (via Docker) | 空间数据存储与空间索引 |
| 🐳 容器化 | Docker + docker-compose | 一键启动 PostGIS + pgAdmin |

---

## 🏗️ 三层架构的 GIS 职责分工

从 GIS 工程角度看，本项目的三层架构对应了**空间数据的三个处理阶段**：

```
  数据源                   业务逻辑                    用户交互
     │                        │                          │
     ▼                        ▼                          ▼
 ┌─────────────┐     ┌──────────────┐     ┌──────────────────┐
 │  数据处理层  │ ──> │   后端服务层  │ ──> │    前端展示层     │
 │  Python     │     │  Java/Spring │     │  Vue 3 + Leaflet │
 │             │     │              │     │                  │
 │  原始空间    │     │  空间查询/    │     │  地图渲染/        │
 │  数据清洗    │     │  业务逻辑     │     │  交互操作/        │
 │  格式转换    │     │  数据持久化   │     │  可视化分析       │
 └─────────────┘     └──────────────┘     └──────────────────┘
```

### 🖥️ 前端层（Frontend）— 地图可视化与交互

**GIS 角色**：展现层 — 将空间数据转换为用户可理解的地图视觉，处理用户的交互操作。

| GIS 职责 | 具体实现 |
|----------|----------|
| 底图加载 | Leaflet 加载 OpenStreetMap / 自定义瓦片图层 |
| 空间数据可视化 | 渲染 GeoJSON 点线面要素、热力图、矢量瓦片 |
| 地图交互 | 缩放、平移、点击查询、框选、拖拽 |
| 空间量算 | 距离测量、面积测量（`MapMeasure_Basic/Enhanced`） |
| 属性查询 | 点击要素弹出属性信息窗口 |
| 符号化渲染 | 根据属性字段配置不同颜色/图标/分级渲染 |
| 客户端坐标转换 | WGS84 / Web Mercator 等投影坐标系前端转换 |

```
数据流：用户 ↔ 地图操作 ↔ API 请求 ↔ 后端
```

### 🔄 数据处理层（Data Processing）— 空间数据分析与预处理

**GIS 角色**：数据工程层 — 负责空间数据的获取、清洗、格式转换、空间分析与特征提取。

| GIS 职责 | 典型工具/方法 |
|----------|--------------|
| 空间数据获取 | GeoPy 地理编码（地址→坐标）、OGR/GDAL 读取矢量/栅格、API 爬取 POI |
| 数据格式转换 | Shapefile ↔ GeoJSON ↔ WKT ↔ TopoJSON 互转 |
| 坐标系重投影 | WGS84 / GCJ-02 / BD-09 互转（`pyproj`、`shapely`） |
| 空间分析 | 缓冲区分析（Buffer）、叠加分析（Intersect/Union）、邻近分析 |
| 数据清洗 | 去除重复要素、修复拓扑错误、填补属性字段空值 |
| 特征提取 | 点聚类、路网简化、面要素中心点提取 |
| 批量处理 | 大文件分块读取、并行计算、结果导出为标准数据格式 |

```
数据流：原始数据 → 清洗/转换 → 结构化空间数据 → 后端 / 前端
```

### ⚙️ 后端层（Backend）— GIS 业务逻辑与数据服务

**GIS 角色**：服务层 — 提供标准化的空间查询接口，管理空间数据库，封装GIS业务规则。

| GIS 职责 | 具体实现 |
|----------|----------|
| 空间数据持久化 | JPA + PostGIS 空间字段（Geometry/Geography 类型） |
| 空间查询接口 | 点查询、矩形查询、圆形范围查询、多边形相交查询 |
| 空间索引 | PostGIS R-Tree 索引（GIST），提升空间检索效率 |
| 地理计算服务 | 距离计算、面积计算、包含关系判定（`ST_Contains` 等） |
| 图层管理 | 矢量图层的 CRUD、样式配置存储、图层分组 |
| 属性字段查询 | 按属性字段过滤（属性查询） |
| 数据服务 API | 标准 RESTful API（请求 → SQL/JPQL → GeoJSON 响应） |
| 空间数据导入导出 | Shapefile / GeoJSON 文件上传解析入库 |

```
数据流：前端/客户端 → REST API → Service 层 → PostGIS → 空间查询结果返回
```

### 🗄️ 空间数据库（PostGIS）

各层共享的基础设施：

| 职责 | 说明 |
|------|------|
| 空间扩展 | PostGIS 提供 Geometry/Geography 类型、空间函数（ST_*）、空间索引 |
| 数据存储 | 矢量要素（点/线/面）、属性字段、坐标系 SRID 元数据 |
| 空间索引 | GIST 索引加速空间查询 |
| 坐标系管理 | `spatial_ref_sys` 表管理数千种坐标系定义 |

### 三层协作流程示例

```
┌─────────┐     ┌──────────┐     ┌───────────┐     ┌──────────┐
│ 原始数据  │ ──> │  数据处理  │ ──> │  后端服务  │ ──> │   前端    │
│(Shapefile)│     │  (Python) │     │(Spring)   │     │(Leaflet) │
└─────────┘     └──────────┘     └───────────┘     └──────────┘
                    │                  │                  │
                    │  清洗/重投影      │  存储到 PostGIS  │  地图渲染
                    │  → GeoJSON       │  → RESTful API   │  → 交互操作
                    ▼                  ▼                  ▼
```

## 📁 目录结构

```
GIS-Project/
│
├── frontend/                       # ── 前端层 ──
│   ├── src/
│   │   ├── components/             #   地图组件 (LeafletMap, MapMeasure 等)
│   │   ├── App.vue                 #   根组件
│   │   ├── main.ts                 #   入口文件
│   │   └── style.css               #   全局样式
│   ├── public/                     #   静态资源 (favicon, icons)
│   ├── index.html                  #   HTML 模板
│   ├── package.json                #   依赖与脚本
│   ├── vite.config.ts              #   Vite 构建配置
│   └── tsconfig.json               #   TypeScript 配置
│
├── backend/                        # ── 后端层 ──
│   ├── src/main/java/com/gis/      #   Java 源码 (App.java 启动入口)
│   ├── src/main/resources/         #   配置文件 (application.properties)
│   ├── src/test/java/com/gis/      #   单元测试 (AppTest.java)
│   └── pom.xml                     #   Maven 项目描述 (Spring Boot 3.4.4)
│
├── data-processing/                # ── 数据处理层 ──
│   ├── scripts/                    #   Python 处理脚本
│   ├── data/                       #   空间数据文件 (GeoJSON, Shapefile 等)
│   ├── notebooks/                  #   Jupyter 分析笔记本
│   ├── requirements.txt            #   Python 依赖清单
│   └── python_env_verification.html #   Python 环境验证报告
│
├── docker-compose.yml              # PostGIS + pgAdmin 容器编排
├── check_env.bat                   # 环境自检 (CMD)
├── check_env.ps1                   # 环境自检 (PowerShell)
├── .gitignore                      # Git 忽略规则
└── README.md                       # 项目说明文档
```

---

## 🚀 快速启动

### 0. 环境自检

```bash
# PowerShell
.\check_env.ps1

# CMD
check_env.bat
```

一键输出 Node.js / pnpm / Python / Java / Git / Docker 版本。

### 1. 前端

```bash
cd frontend
pnpm install
pnpm dev              # 开发服务器 → http://localhost:5173
pnpm build            # 生产构建 → dist/
pnpm preview          # 预览构建结果
```

### 2. 数据处理（Python）

```bash
cd data-processing
python -m venv .venv
source .venv/Scripts/activate
pip install -r requirements.txt
```

### 3. 数据库（Docker）

```bash
docker-compose up -d      # 启动 PostGIS (端口 5432) + pgAdmin (端口 5050)
docker-compose down       # 停止并清理
```

### 4. 后端（Java / Maven）

```bash
cd backend
mvn spring-boot:run       # 启动后端服务 → http://localhost:8080
mvn test                  # 运行测试
mvn package               # 打包为 JAR
```

---

## 🗺️ 前端组件

| 组件 | 功能 |
|------|------|
| [`LeafletMap.vue`](frontend/src/components/LeafletMap.vue) | 地图初始化与基础交互（缩放、平移、底图切换） |
| [`MapMeasure_Basic.vue`](frontend/src/components/MapMeasure_Basic.vue) | 基础距离测量工具 |
| [`MapMeasure_Enhanced.vue`](frontend/src/components/MapMeasure_Enhanced.vue) | 增强测量（面积/距离切换、结果显示） |

---

## 📡 API 概览（开发中）

| 端点 | 方法 | 说明 |
|------|------|------|
| `/api/gis/layers` | `GET` | 获取所有地图图层 |
| `/api/gis/query` | `POST` | 空间查询（点/框选） |
| `/api/health` | `GET` | 服务健康检查 |

> 后端服务启动后访问 `http://localhost:8080/api/health`

---

## 📝 Git 提交规范

本项目使用 **Conventional Commits**：

| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: 添加 Leaflet 地图初始化组件` |
| `fix` | 修复 Bug | `fix: 修复 resize 时地图错位` |
| `chore` | 工程维护 | `chore: 初始化项目，添加 .gitignore` |
| `docs` | 文档更新 | `docs: 更新 README 启动说明` |
| `refactor` | 重构 | `refactor: 提取地图配置为独立模块` |
| `style` | 代码格式 | `style: 统一缩进与分号` |
| `merge` | 分支合并 | `merge: 合并 feature 分支到 main` |

```
格式：<type>: <简短描述>（全部小写，末尾无句号）
```

---

## 🌿 分支策略

```
main ──── 稳定主分支
  └── feature/* ── 功能开发 → PR → --no-ff 合并保留拓扑
```

- **`main`** — 主分支，保持稳定，只接受 PR 合并
- **`feature/*`** — 从 main 创建，开发完成后 PR 合并回 main
- 合并使用 `--no-ff` 保留分支拓扑历史

---

## 🤝 PR 流程

1. 从 `main` 创建 `feature/xxx` 分支
2. 开发 → 本地验证 → Push
3. GitHub 发起 Pull Request → `feature/xxx → main`
4. 填写 PR 描述与自审清单
5. 合并（Merge Pull Request）
6. 删除远程 feature 分支

---

## 🔧 环境要求

| 工具 | 最低版本 | 验证命令 |
|------|---------|----------|
| Node.js | >= 22 | `node --version` |
| pnpm | >= 11 | `pnpm --version` |
| Python | >= 3.12 | `python --version` |
| Java JDK | >= 21 | `java -version` |
| Maven | >= 3.9 | `mvn -version` |
| Docker | 最新 | `docker --version` |
| Git | >= 2.40 | `git --version` |

---

## 📄 许可

本项目仅用于教学目的。Third-party 组件遵循其各自许可。
