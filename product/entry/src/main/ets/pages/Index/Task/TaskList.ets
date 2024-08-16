import { HmList } from '@ohos/basic'
import { getTaskListAPI } from '../../../api'
import { TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../viewmodels/task'
import TaskItemCard from './TaskItemCard'
import { promptAction } from '@kit.ArkUI'

@Component
struct TaskList {
  @State
  queryParams: TaskListParamsModel = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting, // 请求的类型
    page: 1, // 默认请求第一页
    pageSize: 5 // 每页显示5条
  } as TaskListParams)
  @State
  taskListData: TaskInfoItemModel[] = []
  @State
  allPage: number = 1 // 总页数

  // 传参数refresh:表示是否刷新,如果传参数,就是刷新,把列表清空,重新请求数据
  async getTaskList(refresh?: boolean) {
    const result = await getTaskListAPI(this.queryParams)
    if (refresh) {
      this.taskListData = result.items // 直接赋值
    } else {
      // 追加
      this.taskListData = this.taskListData.concat(result.items) // 将下一页数据放置到后面
    }
    this.allPage = result.pages // 获取总页数
    this.queryParams.page++ // 每次页码+1
  }

  // 渲染数据
  @Builder
  renderItem(item: object) {
    TaskItemCard({ item: item as TaskInfoItemModel })
  }

  async onRefresh() {
    this.queryParams.page = 1 // 重新请求第一页数据
    await this.getTaskList(true) // 重新请求数据
  }

  build() {
    HmList({
      finished: this.allPage < this.queryParams.page, // 是否加载完成
      renderItem: (item) => {
        this.renderItem(item)
      },
      dataSource: this.taskListData,
      onLoad: async () => {
        await this.getTaskList()
      },
      onRefresh: async () => {
        await this.onRefresh()
        promptAction.showToast({ message: '刷新成功' })
      },
      loadingText: '在加啦',
      finishText: '--我也是有底线的--'
    })
      .height('100%')
  }
}

export default TaskList