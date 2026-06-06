# GIS 全栈开发项目

智慧城市学院 — 《GIS工程与开发》课程实验

> 三层架构：Vue 3 前端 + Python 数据处理 + Java 后端

---

## 📋 技术栈

| 层次 | 技术 | 用途 |
|------|------|------|
| 前端 | Vue 3 + Vite + TypeScript + Leaflet | 地图可视化与交互界面 |
| 数据处理 | Python 3.12 + geopandas + shapely + geopy | 空间数据获取、清洗、分析 |
| 后端 | Java 21 + Maven (Spring Boot) | GIS 服务接口、空间查询 |
| 版本控制 | Git + GitHub | 代码管理与团队协作 |
| 容器化 | Docker + docker-compose (PostGIS + pgAdmin) | 数据库与中间件部署 |

## 📁 目录结构

```
GIS-Project/
├── frontend/              # 前端层
│   ├── src/               # Vue 3 组件源码
│   │   └── components/    # Leaflet 地图组件
│   ├── public/            # 静态资源
│   └── package.json       # 前端依赖
├── backend/               # 后端层
│   └── pom.xml            # Maven 项目配置
├── data-processing/       # 数据处理层
│   ├── scripts/           # 处理脚本
│   ├── requirements.txt   # Python 依赖
│   └── .venv/             # 虚拟环境
├── docker-compose.yml     # PostGIS + pgAdmin 编排
├── .gitignore             # Git 忽略规则
├── check_env.bat          # 环境自检脚本
└── README.md              # 项目说明文档
```

## 🚀 快速启动

### 前端

```bash
cd frontend
pnpm install
pnpm dev          # 开发服务器 → http://localhost:5173
pnpm build        # 生产构建
pnpm preview      # 预览构建结果
```

### 数据处理

```bash
cd data-processing
python -m venv .venv
source .venv/Scripts/activate
pip install -r requirements.txt
```

### 后端数据库

```bash
docker-compose up -d    # 启动 PostGIS + pgAdmin
docker-compose down     # 停止容器
```

## 📝 Git 提交规范

本项目使用 **Conventional Commits** 规范：

| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: 添加 Leaflet 地图初始化组件` |
| `fix` | 修复 Bug | `fix: 修复窗口 resize 时地图错位` |
| `chore` | 工程维护 | `chore: 初始化项目，添加 .gitignore` |
| `docs` | 文档更新 | `docs: 更新 README 启动说明` |
| `refactor` | 重构 | `refactor: 提取地图配置为独立模块` |
| `merge` | 分支合并 | `merge: 合并 feature 分支到 main` |

格式：`<type>: <简短描述>`（全部小写，末尾无句号）

## 🌿 分支策略

- `main` — 主分支，保持稳定
- `feature/*` — 功能开发分支，完成后 PR 合并回 main
- 合并时使用 `--no-ff` 保留分支拓扑历史

## 🤝 PR 流程

1. 从 `main` 创建 `feature/xxx` 分支
2. 开发完成后 Push 到 GitHub
3. 发起 Pull Request → `feature/xxx → main`
4. 填写 PR 描述与自审清单
5. 合并（Merge Pull Request）

## 🔧 环境要求

| 工具 | 版本要求 |
|------|---------|
| Node.js | >= 22 |
| pnpm | >= 11 |
| Python | >= 3.12 |
| Java JDK | >= 21 |
| Docker | 最新版 |
| Git | >= 2.40 |
