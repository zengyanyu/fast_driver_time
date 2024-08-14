import { Request } from '@ohos/basic'
import { LoginFormModel, UserInfoModel, UserTaskInfoModel, UserTaskInfoParamsModel } from '../viewmodels'

// 登录接口
export const login = (data: LoginFormModel) => {
  return Request.post<string>("/login/account", data)
}

// 获取用户信息
export const getUserInfoAPI = () => {
  return Request.get<UserInfoModel>("/users")
}

// 获取用户的任务数据
export const getUserTaskInfoAPI = (data: UserTaskInfoParamsModel) => {
  return Request.get<UserTaskInfoModel>("/users/taskReport", data)
}