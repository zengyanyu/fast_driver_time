// 任务的请求接口文件
import { RequestAxios } from '@ohos/basic'
import { TaskDetailInfoModel } from '../viewmodels/detail'
import { TaskListDataModel, TaskListParamsModel } from '../viewmodels/task'

// 获取详细信息
export const getTaskListAPI = (params: TaskListParamsModel) => {
  return RequestAxios.get<TaskListDataModel>("/tasks/list", params)
}

// 获取任务详情
export const getTaskDetailAPI = (id: string) => {
  return RequestAxios.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}