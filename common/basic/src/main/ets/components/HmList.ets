import { sound } from '../utils'

@Component
export struct HmList {
  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive // 用来记录下拉的状态
  @State
  refreshIng: boolean = false // 控制下拉刷新的变量
  // 到底还有没有下一页
  @Prop
  finished: boolean = false // 是否已经加载结束
  @Prop
  dataSource: object[] = [] // 数组
  @BuilderParam
  renderItem: (item: object) => void // 负责渲染每一项的结构
  // 上拉加载
  onLoad: () => void = () => {
  }
  // 下拉刷新
  onRefresh: () => void = () => {
  }
  loadingText: string = "拼命加载中..." // 底部的加载提示文本
  finishText: string = "没有拉" // 加载完成的提示文本
  @State
  loading: boolean = false // 是否正在加载  用来控制阀门

  @Builder
  getBottomBuilder() {
    Row({ space: 10 }) {
      // 判断
      if (this.finished) {
        Text(this.finishText)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
      } else {
        if (this.loading) {
          Text(this.loadingText)
            .fontSize(14)
            .fontColor($r("app.color.text_secondary"))
          LoadingProgress()
            .width(20)
            .aspectRatio(1)
            .color($r("app.color.text_secondary"))
        }
      }
    }
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .height(50)
  }

  // 根据不同的状态获取不同的文本
  getStatusText() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return "继续下拉"
      case RefreshStatus.OverDrag:
        return "松手加载"
      case RefreshStatus.Refresh:
        return "加载中"
    }
    return ""
  }

  @Builder
  getRefreshDisplay() {
    // 渲染不同阶段的显示内容
    Row({ space: 10 }) {
      LoadingProgress()
        .width(40)
        .aspectRatio(1)
        .color($r("app.color.primary"))
      Text(this.getStatusText())
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
    }
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .height(50)

  }

  build() {
    Refresh({ refreshing: $$this.refreshIng, builder: this.getRefreshDisplay }) {
      List() {
        ForEach(this.dataSource, (item: object) => {
          ListItem() {
            if (this.renderItem) {
              this.renderItem(item)
            }
          }
        })
        // 底部提示
        ListItem() {
          // 写一个builder
          this.getBottomBuilder()
        }
      }
      .onReachEnd(async () => {
        // 上拉加载
        if (!this.loading && !this.finished) {
          // 现在没有加载 并且明确还有数据 才可以进来
          this.loading = true // 保证当前只有自己在
          await this.onLoad()
          this.loading = false
        }
      })
    }
    .onStateChange(async (state) => {
      // 记录当下的状态
      this.refreshStatus = state
      if (state === RefreshStatus.Refresh) {
        // 松手时触发
        // 刷新 意味者全部重来
        await this.onRefresh()
        // 手动关闭进度
        this.refreshIng = false
        // 关闭loading
        this.loading = false

        sound.playAudio('sound.mp3')
      }
    })
  }
}

