// 数据模型定义

// GitHub 项目模型
export interface GitHubProject {
  id: number
  name: string              // 项目名称
  fullName: string          // 完整名称 (owner/repo)
  htmlUrl: string           // 项目链接
  description: string       // 功能介绍
  stargazersCount: number   // 星数
  language: string          // 主要语言
  createdAt: string         // 创建时间
  updatedAt: string         // 更新时间
  trendingScore: number     // 趋势分数
}

// AI 编程工具模型
export interface AITool {
  id: number
  name: string              // 工具名称
  officialUrl: string       // 官方链接
  description: string       // 功能介绍
  latestUpdate: string      // 最新进展
  updateDate: string        // 更新日期
  usageRank: number         // 使用量排名
  category: string          // 分类
  features: string[]        // 主要特性
}

// 技术趋势分析
export interface TechTrend {
  id: number
  date: string
  period: 'daily' | 'weekly'
  summary: string
  hotTechs: string[]
  emergingTechs: string[]
  recommendations: string[]
  topProjects: GitHubProject[]
}

// AI Agent 趋势
export interface AIAgentTrend {
  id: number
  date: string
  summary: string
  architectures: string[]
  keyFeatures: string[]
  futureOutlook: string
  topTools: AITool[]
}
