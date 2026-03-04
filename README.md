# GitHub 开源趋势追踪器 - HarmonyOS 应用

## 项目概述
这是一个运行在 HarmonyOS 4.2.0.213 上的应用，用于追踪 GitHub 热门开源项目和 AI 编程工具趋势。

## 开发环境要求

### 1. 安装 DevEco Studio
- 下载地址：https://developer.harmonyos.com/cn/develop/deveco-studio/
- 版本要求：DevEco Studio 4.0 或更高版本
- 安装步骤详见：`docs/环境搭建指南.md`

### 2. 注册华为开发者账号
- 访问：https://developer.huawei.com/consumer/cn/
- 完成实名认证
- 创建应用项目，获取 App ID

### 3. 配置签名证书
- 在 DevEco Studio 中配置自动签名
- 或手动生成签名证书

## 项目结构
```
GitHubTrendsApp/
├── entry/                      # 主模块
│   ├── src/main/
│   │   ├── ets/               # ArkTS 代码
│   │   │   ├── pages/         # 页面
│   │   │   ├── components/    # 组件
│   │   │   ├── services/      # 服务层
│   │   │   ├── utils/         # 工具类
│   │   │   └── model/         # 数据模型
│   │   └── resources/         # 资源文件
│   └── build-profile.json5    # 模块配置
├── docs/                       # 文档
└── build-profile.json5        # 项目配置
```

## 核心功能

### 1. 每日 GitHub 热门项目
- 获取前一天星数 Top 10 项目
- 显示项目名称、链接、功能介绍
- 分析技术发展趋势

### 2. 每周 GitHub 趋势
- 每周日自动获取本周热门项目
- 提供学习方向指导

### 3. AI 编程工具追踪
- 追踪主流 AI 编程工具动态
- 分析 Agent 发展趋势

## 开发流程

### 第一步：环境搭建
详见 `docs/环境搭建指南.md`

### 第二步：项目导入
1. 打开 DevEco Studio
2. 选择 "Open Project"
3. 选择 GitHubTrendsApp 目录

### 第三步：配置项目
1. 修改 `entry/build-profile.json5` 中的 bundleName
2. 配置网络权限
3. 配置签名

### 第四步：开发调试
1. 连接真机或启动模拟器
2. 点击运行按钮
3. 查看日志和调试

### 第五步：编译打包
1. Build -> Build Hap(s)/APP(s) -> Build APP(s)
2. 生成 .app 文件

### 第六步：发布
1. 上传到华为应用市场
2. 或通过 DevEco Studio 直接安装

## 技术栈
- 语言：ArkTS (TypeScript 超集)
- UI 框架：ArkUI (声明式 UI)
- 网络请求：@ohos.net.http
- 数据存储：@ohos.data.preferences
- 定时任务：@ohos.reminderAgentManager

## 注意事项
1. 需要申请网络权限
2. GitHub API 有调用限制，建议使用 Token
3. 需要处理后端数据解析（可能需要搭建中间层）
4. 定时任务需要在系统设置中授权

## 快速开始
```bash
# 1. 安装 DevEco Studio
# 2. 导入项目
# 3. 配置签名
# 4. 连接设备
# 5. 运行项目
```

## 后续优化
- [ ] 添加本地缓存
- [ ] 支持离线查看
- [ ] 添加推送通知
- [ ] 支持多语言
- [ ] 深色模式
