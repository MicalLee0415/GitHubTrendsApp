import { AITool } from '../model/DataModel'

// AI 工具卡片组件
@Component
export struct AIToolCard {
  @Prop tool: AITool
  private onCardClick?: (tool: AITool) => void

  build() {
    Column() {
      // 头部：工具名称和排名
      Row() {
        Column() {
          Text(this.tool.name)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1D1D1F')
          
          Text(this.tool.category)
            .fontSize(12)
            .fontColor('#86868B')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 排名徽章
        Column() {
          Text(`#${this.tool.usageRank}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
          Text('使用排名')
            .fontSize(10)
            .fontColor('#FFFFFF')
            .opacity(0.9)
        }
        .width(50)
        .height(50)
        .borderRadius(25)
        .backgroundColor(this.getRankColor(this.tool.usageRank))
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 描述
      Text(this.tool.description)
        .fontSize(14)
        .fontColor('#6E6E73')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 12 })

      // 最新进展
      Row() {
        Text('最新进展:')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1D1D1F')
      }
      .width('100%')
      .margin({ bottom: 6 })

      Text(this.tool.latestUpdate)
        .fontSize(13)
        .fontColor('#6E6E73')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 12 })

      // 主要特性标签
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.tool.features.slice(0, 4), (feature: string) => {
          Text(feature)
            .fontSize(11)
            .fontColor('#007AFF')
            .backgroundColor('#E5F1FF')
            .borderRadius(8)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .margin({ right: 6, bottom: 6 })
        })
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 底部：更新时间和链接
      Row() {
        Text(`更新于 ${this.tool.updateDate}`)
          .fontSize(12)
          .fontColor('#86868B')

        Blank()

        Text('访问官网 →')
          .fontSize(13)
          .fontColor('#007AFF')
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
        this.onCardClick(this.tool)
      }
    })
  }

  // 获取排名对应的颜色
  private getRankColor(rank: number): string {
    if (rank === 1) return '#FFD700'  // 金色
    if (rank === 2) return '#C0C0C0'  // 银色
    if (rank === 3) return '#CD7F32'  // 铜色
    return '#8E8E93'
  }
}
