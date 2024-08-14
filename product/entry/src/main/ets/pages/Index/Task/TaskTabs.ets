import { TabClass } from '@ohos/basic'

@Component
struct TaskTabs {
  @State
  tabsData: TabClass[] = [{
    title: '待提货',
    name: 'waiting',
  }, {
    title: '在途',
    name: 'line',
  }, {
    title: '已完成',
    name: 'finish',
  }]

  build() {
    Tabs() {
      ForEach(this.tabsData, (item: TabClass) => {
        TabContent() {
          Text(item.title)
        }
        .tabBar(
          SubTabBarStyle.of(item.title)
            .indicator({
              color: $r("app.color.primary"),
              height: 4,
              borderRadius: 2
            }).labelStyle({
            selectedColor: $r("app.color.text_primary"),
            unselectedColor: $r("app.color.text_secondary")
          })
            .padding({
              right: item.name === "finish" ? 150 : 0,
              left: 30
            })
        )
      })
    }
    .barMode(BarMode.Scrollable)
    .barHeight(60)
    .barBackgroundColor($r("app.color.white"))
    .backgroundColor($r("app.color.background_page"))

    // .padding({
    //   top: AppStorage.get<number>(APP_TOP_HEIGHT)
    // })
  }
}

export default TaskTabs