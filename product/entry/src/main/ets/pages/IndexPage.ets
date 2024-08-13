import { promptAction } from '@kit.ArkUI';

// 滚动条_tabs的显示
@Entry
@Component
struct IndexPage {
  private controller: TabsController = new TabsController();
  tabList: Array<number> =
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
      20]
  @State
  currentIndex: number = 0;

  build() {
    Column() {
      Tabs({ controller: this.controller }) {
        ForEach(this.tabList, (item: number) => {
          TabContent() {
            Column() {
              Text(item.toString())
                .fontSize(40)
            }
            .width('100%')
            .height('100%')
            .borderRadius(12)
            .backgroundColor(Color.Brown)
          }.tabBar(
            SubTabBarStyle.of(item.toString())
              .indicator({
                color: Color.Orange,
                height: 3,
                width: 20,
                marginTop: 5
              })
              .labelStyle({
                // 设置选中颜色
                selectedColor: Color.Orange,
                // 设置未选中颜色
                unselectedColor: Color.Gray
              })
          )
        })
      }.barMode(BarMode.Scrollable)
      .animationDuration(0)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.currentIndex = targetIndex;
      })
      .onTabBarClick((index) => {
        promptAction.showToast({
          message: '显示当前索引:' + index
        })
      })
    }.width('100%').height('100%').padding({ left: '24vp', right: '24vp' })
  }
}

//