import { TabClass } from '@ohos/basic'
import My from './My/My'
import TaskTabs from './Task/TaskTabs'

@Entry
@Component
struct Index {
  @State tabsData: TabClass[] = [{
    title: '任务',
    name: 'task',
    icon: $r("app.media.ic_tab_btn_task")
  }, {
    title: '消息',
    name: 'message',
    icon: $r("app.media.ic_tab_btn_mess_nor")
  }, {
    title: '我的',
    name: 'my',
    icon: $r("app.media.ic_tab_btn_mine_nor")
  }]
  @State
  @Watch("updateName")
  activeIndex: number = 0
  @Provide
  currentName: string = "" // 记录当前的卡片的name

  updateName() {
    // 通过索引找name名称
    this.currentName = this.tabsData[this.activeIndex].name
  }

  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon).width(22).height(22)
        .fillColor(item.name === this.tabsData[this.activeIndex].name ?
        $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(item.name === this.tabsData[this.activeIndex].name ?
        $r('app.color.primary') : $r('app.color.text_secondary'))
    }.alignItems(HorizontalAlign.Center)
  }

  build() {
    Tabs({ index: $$this.activeIndex }) {
      ForEach(this.tabsData, (item: TabClass) => {
        TabContent() {
          if (item.name === 'task') {
            TaskTabs();
          } else if (item.name === 'message') {
            Text(`消息组件${this.activeIndex}`)
          } else {
            My()
          }
        }.tabBar(this.getTabBar(item))
      })
    }.barPosition(BarPosition.End)
  }
}