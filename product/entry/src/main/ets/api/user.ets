import { Request } from '@ohos/basic'
import { LoginFormModel } from '../viewmodels'

// 登录接口
export const login = (data: LoginFormModel) => {
  return Request.post<string>("/login/account", data)
}