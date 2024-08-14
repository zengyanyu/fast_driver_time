import { BASE_URL, TOKEN_KEY } from '../constants'
import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { promptAction, router } from '@kit.ArkUI'
import { UserSettingClass } from '.'

// 创建一个新的实例对象
const instance = axios.create({
  baseURL: BASE_URL,
  timeout: 10000
})

// 两个拦截器
// 请求拦截器
// 响应拦截器

// 1. 成功 2.失败
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 请求的参数
  if (AppStorage.get(TOKEN_KEY)) {
    config.headers.Authorization = AppStorage.get(TOKEN_KEY) // 注入token
  }
  return config
}, (error: AxiosError) => {
  promptAction.showToast({ message: error.message })
  return Promise.reject(error)
})

// 响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  if (response.data && response.data?.code === 200) {
    return response.data?.data // 加个判断 有可能没有返回值
  } else {
    // 不等直接reject
    promptAction.showToast({ message: response.data.msg })
    return Promise.reject(new Error(response.data.msg))
  }
}, (error: AxiosError) => {
  if (error?.status === 401) {
    new UserSettingClass(getContext()).setToken("") // 清空首选项
    AppStorage.setOrCreate(TOKEN_KEY, "") // 设置全局的token为空
    router.replaceUrl({
      url: 'pages/Login/Login' // 跳转到登录页
    })
    return Promise.reject(new Error("登录失效"))
  }
  promptAction.showToast({ message: error.message })
  return Promise.reject(error)
})


export class RequestAxios {
  // get -> params -> { params: {} }
  static get<T>(url: string, params?: object): Promise<T> {
    return instance.get<null, T>(url, { params })
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return instance.post<null, T>(url, data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return instance.delete<null, T>(url, data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return instance.put<null, T>(url, data)
  }
}