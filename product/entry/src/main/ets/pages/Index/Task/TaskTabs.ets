import { TabClass } from '@ohos/basic'
import { TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../viewmodels/task'
import TaskList from './TaskList'

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
          if (item.name === 'waiting') { // 待提货
            TaskList()
          } else if (item.name === 'line') { // 在途
            TaskList({
              queryParams: new TaskListParamsModel({
                status: TaskTypeEnum.Line, // 请求的类型
                page: 1, // 默认请求第一页
                pageSize: 5 // 每页显示5条
              } as TaskListParams)
            })
          } else {
            // 已完成
            Text(item.title)
          }
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
  }
}

export default TaskTabs

