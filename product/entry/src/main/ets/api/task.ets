// 任务的请求接口文件
import { RequestAxios } from '@ohos/basic'
import { DelayParamsTypeModel, ExceptionParamsTypeModel, PickUpParamsModel } from '../viewmodels'
import { CarRecordTypeModel } from '../viewmodels/car_record'
import { DeliverParamsTypeModel } from '../viewmodels/deliver'
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

// 提货api
export const pickUpAPI = (data: PickUpParamsModel) => {
  return RequestAxios.post<null>("/tasks/takeDelivery", data)
}

// 交货api
export const deliverAPI = (data: DeliverParamsTypeModel) => {
  return RequestAxios.post<null>("/tasks/deliver", data)
}

// 回车登记
export const carRecordAPI = (data: CarRecordTypeModel) => {
  return RequestAxios.post<null>("/tasks/truckRegistration", data)
}

// 上报异常
export const exportExceptionAPI = (data: ExceptionParamsTypeModel) => {
  return RequestAxios.post<null>("/tasks/reportException", data)
}

// 延迟提货
export const delayAPI = (data: DelayParamsTypeModel) => {
  return RequestAxios.put<null>('/tasks/delay', data);
}
