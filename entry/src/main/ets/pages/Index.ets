import { GitHubProject, AITool, TechTrend, AIAgentTrend } from '../model/DataModel'
import { GitHubService } from '../services/GitHubService'
import { ProjectCard } from '../components/ProjectCard'
import { AIToolCard } from '../components/AIToolCard'

// 标签页枚举
enum TabIndex {
  DailyTrends = 0,
  WeeklyTrends = 1,
  AITools = 2
}

@Entry
@Component
struct Index {
  @State currentTab: number = TabIndex.DailyTrends
  @State dailyProjects: GitHubProject[] = []
  @State weeklyProjects: GitHubProject[] = []
  @State aiTools: AITool[] = []
  @State techTrend: TechTrend | null = null
  @State aiTrend: AIAgentTrend | null = null
  @State isLoading: boolean = false
  @State lastUpdateTime: string = ''

  private githubService: GitHubService = new GitHubService()

  aboutToAppear() {
    this.loadData()
  }

  // 加载数据
  async loadData() {
    this.isLoading = true
    
    try {
      // 加载每日项目
      this.dailyProjects = await this.githubService.getDailyTopProjects()
      this.techTrend = await this.githubService.analyzeTechTrend(this.dailyProjects, 'daily')
      
      // 加载 AI 工具
      this.aiTools = await this.githubService.getAIToolsProgress()
      this.aiTrend = await this.githubService.analyzeAIAgentTrend(this.aiTools)
      
      this.lastUpdateTime = new Date().toLocaleTimeString('zh-CN')
    } catch (error) {
      console.error('加载数据失败:', error)
    } finally {
      this.isLoading = false
    }
  }

  // 加载每周数据
  async loadWeeklyData() {
    if (this.weeklyProjects.length === 0) {
      this.isLoading = true
      try {
        this.weeklyProjects = await this.githubService.getWeeklyTopProjects()
        this.techTrend = await this.githubService.analyzeTechTrend(this.weeklyProjects, 'weekly')
      } catch (error) {
        console.error('加载每周数据失败:', error)
      } finally {
        this.isLoading = false
      }
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      this.NavigationBar()
      
      // 标签栏
      this.TabBar()
      
      // 内容区域
      if (this.isLoading) {
        this.LoadingView()
      } else {
        this.ContentArea()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F7')
  }

  // 导航栏
  @Builder
  NavigationBar() {
    Row() {
      Text('GitHub 开源趋势')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1D1D1F')
      
      Blank()
      
      Row() {
        Text(this.lastUpdateTime)
          .fontSize(12)
          .fontColor('#86868B')
          .margin({ right: 12 })
        
        // 刷新按钮
        Text('🔄')
          .fontSize(20)
          .onClick(() => this.loadData())
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 12 })
    .backgroundColor('#FFFFFF')
  }

  // 标签栏
  @Builder
  TabBar() {
    Row() {
      ForEach([
        { index: TabIndex.DailyTrends, title: '今日热门' },
        { index: TabIndex.WeeklyTrends, title: '本周趋势' },
        { index: TabIndex.AITools, title: 'AI 工具' }
      ], (tab: { index: number; title: string }) => {
        Column() {
          Text(tab.title)
            .fontSize(15)
            .fontWeight(this.currentTab === tab.index ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === tab.index ? '#007AFF' : '#86868B')
          
          if (this.currentTab === tab.index) {
            Divider()
              .width(20)
              .height(2)
              .color('#007AFF')
              .margin({ top: 4 })
          }
        }
        .layoutWeight(1)
        .padding({ top: 12, bottom: 12 })
        .onClick(() => {
          this.currentTab = tab.index
          if (tab.index === TabIndex.WeeklyTrends) {
            this.loadWeeklyData()
          }
        })
      })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .border({ width: { bottom: 0.5 }, color: '#E5E5EA' })
  }

  // 加载视图
  @Builder
  LoadingView() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
        .color('#007AFF')
      
      Text('加载中...')
        .fontSize(14)
        .fontColor('#86868B')
        .margin({ top: 12 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  // 内容区域
  @Builder
  ContentArea() {
    Scroll() {
      Column() {
        if (this.currentTab === TabIndex.DailyTrends) {
          this.DailyTrendsView()
        } else if (this.currentTab === TabIndex.WeeklyTrends) {
          this.WeeklyTrendsView()
        } else {
          this.AIToolsView()
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }

  // 每日热门视图
  @Builder
  DailyTrendsView() {
    Column() {
      // 趋势分析卡片
      if (this.techTrend) {
        this.TrendSummaryCard(this.techTrend)
      }
      
      // 项目列表
      ForEach(this.dailyProjects, (project: GitHubProject) => {
        ProjectCard({ 
          project: project,
          onCardClick: (proj: GitHubProject) => {
            console.info('点击项目:', proj.name)
            // TODO: 打开项目详情或浏览器
          }
        })
        .margin({ bottom: 12 })
      })
    }
  }

  // 每周趋势视图
  @Builder
  WeeklyTrendsView() {
    Column() {
      // 学习建议卡片
      if (this.techTrend) {
        this.LearningGuideCard(this.techTrend)
      }
      
      // 项目列表
      ForEach(this.weeklyProjects, (project: GitHubProject) => {
        ProjectCard({ 
          project: project,
          onCardClick: (proj: GitHubProject) => {
            console.info('点击项目:', proj.name)
          }
        })
        .margin({ bottom: 12 })
      })
    }
  }

  // AI 工具视图
  @Builder
  AIToolsView() {
    Column() {
      // AI 趋势分析卡片
      if (this.aiTrend) {
        this.AITrendCard(this.aiTrend)
      }
      
      // AI 工具列表
      ForEach(this.aiTools, (tool: AITool) => {
        AIToolCard({ 
          tool: tool,
          onCardClick: (t: AITool) => {
            console.info('点击工具:', t.name)
          }
        })
        .margin({ bottom: 12 })
      })
    }
  }

  // 趋势总结卡片
  @Builder
  TrendSummaryCard(trend: TechTrend) {
    Column() {
      Row() {
        Text('📊 趋势分析')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1D1D1F')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Text(trend.summary)
        .fontSize(14)
        .fontColor('#6E6E73')
        .lineHeight(22)
        .margin({ bottom: 12 })

      // 热门技术标签
      Row() {
        Text('热门技术:')
          .fontSize(13)
          .fontColor('#86868B')
          .margin({ right: 8 })
        
        ForEach(trend.hotTechs.slice(0, 4), (tech: string) => {
          Text(tech)
            .fontSize(12)
            .fontColor('#007AFF')
            .backgroundColor('#E5F1FF')
            .borderRadius(8)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .margin({ right: 6 })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 16 })
  }

  // 学习指导卡片
  @Builder
  LearningGuideCard(trend: TechTrend) {
    Column() {
      Row() {
        Text('💡 学习建议')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1D1D1F')
      }
      .width('100%')
      .margin({ bottom: 12 })

      ForEach(trend.recommendations, (rec: string, index: number) => {
        Row() {
          Text(`${index + 1}.`)
            .fontSize(14)
            .fontColor('#007AFF')
            .margin({ right: 8 })
          
          Text(rec)
            .fontSize(14)
            .fontColor('#6E6E73')
            .layoutWeight(1)
        }
        .width('100%')
        .margin({ bottom: 8 })
        .alignItems(VerticalAlign.Top)
      })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 16 })
  }

  // AI 趋势卡片
  @Builder
  AITrendCard(trend: AIAgentTrend) {
    Column() {
      Row() {
        Text('🤖 AI Agent 趋势')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1D1D1F')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Text(trend.summary)
        .fontSize(14)
        .fontColor('#6E6E73')
        .lineHeight(22)
        .margin({ bottom: 12 })

      // 主要架构
      Row() {
        Text('主要架构:')
          .fontSize(13)
          .fontColor('#86868B')
      }
      .width('100%')
      .margin({ bottom: 6 })

      ForEach(trend.architectures.slice(0, 3), (arch: string) => {
        Row() {
          Text('•')
            .fontSize(13)
            .fontColor('#007AFF')
            .margin({ right: 8 })
          Text(arch)
            .fontSize(13)
            .fontColor('#6E6E73')
        }
        .width('100%')
        .margin({ bottom: 4 })
      })

      Text(trend.futureOutlook)
        .fontSize(13)
        .fontColor('#86868B')
        .margin({ top: 12 })
        .italic()
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 16 })
  }
}
