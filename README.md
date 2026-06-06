# GIS 全栈开发项目

智慧城市学院 — 《GIS工程与开发》课程实验

## 技术栈

| 层次 | 技术 | 用途 |
|------|------|------|
| 前端 | Vue 3 + Vite + TypeScript + Leaflet | 地图可视化与交互界面 |
| 数据处理 | Python 3.12 + geopandas + shapely | 空间数据获取、清洗、分析 |
| 后端 | Java 21 + Maven (Spring Boot) | GIS 服务接口、空间查询 |
| 版本控制 | Git + GitHub | 代码管理与团队协作 |

## 目录结构

```
GIS-Project/
├── frontend/           # 前端层
│   ├── src/            # Vue 3 组件源码
│   ├── public/         # 静态资源
│   └── package.json    # 前端依赖
├── backend/            # 后端层
│   └── pom.xml         # Maven 项目配置
├── data-processing/    # 数据处理层
│   ├── .venv/          # Python 虚拟环境
│   ├── scripts/        # 处理脚本
│   └── requirements.txt
├── .gitignore
└── README.md
```

## 快速启动

```bash
# 前端
cd frontend && pnpm install && pnpm dev

# 数据处理
cd data-processing && python -m venv .venv
source .venv/Scripts/activate && pip install -r requirements.txt
```

## 开发分支

- main: 主分支
- feature/gis-demo: 功能开发分支
- feature/test: 测试功能分支
