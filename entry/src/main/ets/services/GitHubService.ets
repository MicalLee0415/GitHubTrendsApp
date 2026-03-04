import http from '@ohos.net.http'
import { GitHubProject, TechTrend, AITool, AIAgentTrend } from '../model/DataModel'

// GitHub API 服务
export class GitHubService {
  private readonly baseUrl = 'https://api.github.com'
  private readonly token = 'YOUR_GITHUB_TOKEN' // 建议配置 GitHub Token

  // 获取前一天星数 Top 10 项目
  async getDailyTopProjects(): Promise<GitHubProject[]> {
    const httpRequest = http.createHttp()
    
    try {
      const yesterday = this.getYesterdayDate()
      const url = `${this.baseUrl}/search/repositories?q=created:>${yesterday}&sort=stars&order=desc&per_page=10`
      
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Authorization': `token ${this.token}`,
          'Accept': 'application/vnd.github.v3+json'
        }
      })

      if (response.responseCode === 200) {
        const result = JSON.parse(response.result as string)
        return result.items.map((item: any) => this.parseGitHubProject(item))
      } else {
        throw new Error(`请求失败: ${response.responseCode}`)
      }
    } catch (error) {
      console.error('获取 GitHub 项目失败:', error)
      return this.getMockProjects()
    } finally {
      httpRequest.destroy()
    }
  }

  // 获取本周星数 Top 10 项目
  async getWeeklyTopProjects(): Promise<GitHubProject[]> {
    const httpRequest = http.createHttp()
    
    try {
      const weekAgo = this.getWeekAgoDate()
      const url = `${this.baseUrl}/search/repositories?q=created:>${weekAgo}&sort=stars&order=desc&per_page=10`
      
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Authorization': `token ${this.token}`,
          'Accept': 'application/vnd.github.v3+json'
        }
      })

      if (response.responseCode === 200) {
        const result = JSON.parse(response.result as string)
        return result.items.map((item: any) => this.parseGitHubProject(item))
      } else {
        throw new Error(`请求失败: ${response.responseCode}`)
      }
    } catch (error) {
      console.error('获取本周 GitHub 项目失败:', error)
      return this.getMockProjects()
    } finally {
      httpRequest.destroy()
    }
  }

  // 分析技术趋势
  async analyzeTechTrend(projects: GitHubProject[], period: 'daily' | 'weekly'): Promise<TechTrend> {
    // 统计编程语言分布
    const languageCount: Map<string, number> = new Map()
    projects.forEach(project => {
      if (project.language) {
        languageCount.set(project.language, (languageCount.get(project.language) || 0) + 1)
      }
    })

    // 提取热门技术
    const hotTechs = Array.from(languageCount.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(item => item[0])

    // 生成趋势总结
    const summary = this.generateTrendSummary(projects, hotTechs)

    // 生成学习建议
    const recommendations = this.generateRecommendations(hotTechs, projects)

    return {
      id: Date.now(),
      date: new Date().toISOString().split('T')[0],
      period: period,
      summary: summary,
      hotTechs: hotTechs,
      emergingTechs: this.identifyEmergingTechs(projects),
      recommendations: recommendations,
      topProjects: projects
    }
  }

  // 获取 AI 编程工具进展
  async getAIToolsProgress(): Promise<AITool[]> {
    // 由于没有专门的 API，这里使用预设数据
    // 实际应用中应该从技术博客、官方发布等渠道获取
    return this.getMockAITools()
  }

  // 分析 AI Agent 趋势
  async analyzeAIAgentTrend(tools: AITool[]): Promise<AIAgentTrend> {
    const architectures = [
      'ReAct (Reasoning + Acting)',
      'RAG (Retrieval-Augmented Generation)',
      'Multi-Agent Collaboration',
      'Chain-of-Thought Prompting',
      'Tool Use & Function Calling'
    ]

    const keyFeatures = [
      '上下文理解和记忆',
      '多模态能力（代码、文本、图像）',
      '实时协作编辑',
      '智能代码补全',
      '自动化测试生成',
      '代码审查和优化'
    ]

    return {
      id: Date.now(),
      date: new Date().toISOString().split('T')[0],
      summary: 'AI 编程工具正从简单的代码补全向智能化、协作化方向发展，多 Agent 架构和 RAG 技术成为主流。',
      architectures: architectures,
      keyFeatures: keyFeatures,
      futureOutlook: '未来将更加注重隐私保护、本地化部署、以及与开发流程的深度集成。',
      topTools: tools
    }
  }

  // 辅助方法：解析 GitHub 项目
  private parseGitHubProject(item: any): GitHubProject {
    return {
      id: item.id,
      name: item.name,
      fullName: item.full_name,
      htmlUrl: item.html_url,
      description: item.description || '暂无描述',
      stargazersCount: item.stargazers_count,
      language: item.language || 'Unknown',
      createdAt: item.created_at,
      updatedAt: item.updated_at,
      trendingScore: this.calculateTrendingScore(item)
    }
  }

  // 辅助方法：计算趋势分数
  private calculateTrendingScore(item: any): number {
    const starWeight = 1
    const forkWeight = 0.5
    const recentUpdateWeight = 2
    
    const daysSinceUpdate = (Date.now() - new Date(item.updated_at).getTime()) / (1000 * 60 * 60 * 24)
    const recentUpdateBonus = Math.max(0, (30 - daysSinceUpdate) / 30)
    
    return item.stargazers_count * starWeight + 
           item.forks_count * forkWeight + 
           recentUpdateBonus * recentUpdateWeight * 100
  }

  // 辅助方法：获取昨天日期
  private getYesterdayDate(): string {
    const date = new Date()
    date.setDate(date.getDate() - 1)
    return date.toISOString().split('T')[0]
  }

  // 辅助方法：获取一周前日期
  private getWeekAgoDate(): string {
    const date = new Date()
    date.setDate(date.getDate() - 7)
    return date.toISOString().split('T')[0]
  }

  // 辅助方法：生成趋势总结
  private generateTrendSummary(projects: GitHubProject[], hotTechs: string[]): string {
    const topLang = hotTechs[0] || '未知'
    const avgStars = Math.round(projects.reduce((sum, p) => sum + p.stargazersCount, 0) / projects.length)
    
    return `近期 ${hotTechs.slice(0, 3).join('、')} 等技术备受关注，` +
           `其中 ${topLang} 项目数量最多。` +
           `Top 10 项目平均获得 ${avgStars} 个星标，` +
           `显示出开发者社区的活跃度。`
  }

  // 辅助方法：生成学习建议
  private generateRecommendations(hotTechs: string[], projects: GitHubProject[]): string[] {
    const recommendations: string[] = []
    
    if (hotTechs.includes('TypeScript')) {
      recommendations.push('TypeScript 持续火热，建议深入学习类型系统和高级特性')
    }
    if (hotTechs.includes('Rust')) {
      recommendations.push('Rust 在系统编程领域崭露头角，适合学习内存安全和并发编程')
    }
    if (hotTechs.includes('Python')) {
      recommendations.push('Python 在 AI/ML 领域仍是主流，可以关注相关库和框架')
    }
    
    recommendations.push('关注 AI 辅助开发工具，提高开发效率')
    recommendations.push('参与开源项目，积累实战经验')
    
    return recommendations.slice(0, 5)
  }

  // 辅助方法：识别新兴技术
  private identifyEmergingTechs(projects: GitHubProject[]): string[] {
    const emergingKeywords = ['AI', 'LLM', 'WebAssembly', 'Edge Computing', 'Quantum']
    const emergingTechs: string[] = []
    
    projects.forEach(project => {
      emergingKeywords.forEach(keyword => {
        if (project.description.toLowerCase().includes(keyword.toLowerCase()) && 
            !emergingTechs.includes(keyword)) {
          emergingTechs.push(keyword)
        }
      })
    })
    
    return emergingTechs.slice(0, 3)
  }

  // Mock 数据：GitHub 项目
  private getMockProjects(): GitHubProject[] {
    return [
      {
        id: 1,
        name: 'awesome-ai-tools',
        fullName: 'developer/awesome-ai-tools',
        htmlUrl: 'https://github.com/developer/awesome-ai-tools',
        description: 'AI 编程工具合集，涵盖代码生成、测试、审查等多个领域',
        stargazersCount: 12500,
        language: 'Python',
        createdAt: '2024-01-15',
        updatedAt: '2025-01-20',
        trendingScore: 95
      },
      {
        id: 2,
        name: 'llm-code-assistant',
        fullName: 'aistudio/llm-code-assistant',
        htmlUrl: 'https://github.com/aistudio/llm-code-assistant',
        description: '基于大语言模型的智能编程助手，支持多种编程语言',
        stargazersCount: 10800,
        language: 'TypeScript',
        createdAt: '2024-02-20',
        updatedAt: '2025-01-21',
        trendingScore: 92
      }
    ]
  }

  // Mock 数据：AI 工具
  private getMockAITools(): AITool[] {
    return [
      {
        id: 1,
        name: 'GitHub Copilot',
        officialUrl: 'https://github.com/features/copilot',
        description: 'AI 结对程序员，提供实时代码建议',
        latestUpdate: '支持更多语言和框架，增强上下文理解能力',
        updateDate: '2025-01-15',
        usageRank: 1,
        category: 'IDE插件',
        features: ['代码补全', '函数生成', '单元测试', '文档生成']
      },
      {
        id: 2,
        name: 'Cursor',
        officialUrl: 'https://cursor.sh',
        description: 'AI 优先的代码编辑器',
        latestUpdate: '新增多文件编辑和代码库理解功能',
        updateDate: '2025-01-18',
        usageRank: 2,
        category: '独立工具',
        features: ['智能重构', '代码解释', 'Bug 修复', 'Chat 界面']
      },
      {
        id: 3,
        name: 'Claude for Code',
        officialUrl: 'https://claude.ai',
        description: 'Anthropic 的 AI 助手，擅长代码任务',
        latestUpdate: '改进长代码库的理解能力，支持 Artifacts',
        updateDate: '2025-01-20',
        usageRank: 3,
        category: '云端服务',
        features: ['代码审查', '架构设计', '调试协助', '技术文档']
      }
    ]
  }
}
