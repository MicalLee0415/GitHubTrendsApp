import { GitHubProject } from '../model/DataModel'

// 项目卡片组件 - 苹果风格设计
@Component
export struct ProjectCard {
  @Prop project: GitHubProject
  private onCardClick?: (project: GitHubProject) => void

  build() {
    Column() {
      // 头部：项目名称和语言标签
      Row() {
        Text(this.project.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1D1D1F')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)

        // 语言标签
        if (this.project.language !== 'Unknown') {
          Text(this.project.language)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor(this.getLanguageColor(this.project.language))
            .borderRadius(10)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        }
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 描述
      Text(this.project.description)
        .fontSize(14)
        .fontColor('#6E6E73')
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .lineHeight(20)
        .margin({ bottom: 12 })

      // 底部：统计信息
      Row() {
        // 星数
        Row() {
          Text('⭐')
            .fontSize(14)
          Text(this.formatNumber(this.project.stargazersCount))
            .fontSize(14)
            .fontColor('#86868B')
            .margin({ left: 4 })
        }

        Blank()

        // 查看详情按钮
        Row() {
          Text('查看详情')
            .fontSize(13)
            .fontColor('#007AFF')
          Text(' →')
            .fontSize(13)
            .fontColor('#007AFF')
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ 
      radius: 8, 
      color: 'rgba(0, 0, 0, 0.08)', 
      offsetX: 0, 
      offsetY: 2 
    })
    .onClick(() => {
      if (this.onCardClick) {
        this.onCardClick(this.project)
      }
    })
  }

  // 获取语言对应的颜色
  private getLanguageColor(language: string): string {
    const colorMap: Record<string, string> = {
      'JavaScript': '#F7DF1E',
      'TypeScript': '#3178C6',
      'Python': '#3776AB',
      'Java': '#ED8B00',
      'Go': '#00ADD8',
      'Rust': '#CE412B',
      'C++': '#00599C',
      'C': '#A8B9CC',
      'Swift': '#FA7343',
      'Kotlin': '#7F52FF'
    }
    return colorMap[language] || '#8E8E93'
  }

  // 格式化数字
  private formatNumber(num: number): string {
    if (num >= 1000) {
      return (num / 1000).toFixed(1) + 'k'
    }
    return num.toString()
  }
}
