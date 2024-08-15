// 请求工具
// 增 删 改 查

// get post put delete
import { BASE_URL, TOKEN_KEY } from '../constants' // 基础地址
import http from '@ohos.net.http' // 原生
import { ResponseData } from '../viewmodels'
import { UserSettingClass } from './setting'
import { promptAction, router } from '@kit.ArkUI'


// 基本的请求工具 对http的进一步封装
async function requestHttp<T>(url: string, method: http.RequestMethod = http.RequestMethod.GET, data?: object) {
  const httpRequest = http.createHttp() // 创建请求对象
  let urlStr = BASE_URL + url // 完成地址拼接
  // get请求  => get只能通过url地址向后端发送参数
  if (method === http.RequestMethod.GET) {
    // 判断对象不为空
    if (data && Object.keys(data).length) {
      // url?a=1&b=2&c=3
      urlStr += "?" + Object.keys(data).filter(key =>!!data[key]).map(key => {
        return `${key}=${data[key]}` // ["a=1", "b=2", "c=3"]
      }).join("&")
    }
  }
  // get类型处理完毕
  let config: http.HttpRequestOptions = {
    method, // 请求类型
    header: {
      // 接口都需要token
      Authorization: AppStorage.get(TOKEN_KEY) || "", // token从全局状态中取
      "Content-Type": "application/json"  // 设置传入的参数是json结构
    },
    readTimeout: 10000, // 超时时间
    extraData: method === http.RequestMethod.GET ? "" : data // 除了get之外所有的请求体参数
  }
  try {
    const res = await httpRequest.request(urlStr, config)
    // 还有一些异常
    // 401 404 包括一些其他异常
    if (res.responseCode === 401) {
      // token失效 -> token没有存在的意义- 自己的登录-接口没有换token这个操作
      // web登录- token（2小时）- refreshToken(半个月或者更长)
      // 华为登录- 180天有效期 不需要用户自己换token- 后台自己完成的
      // 删除token
      new UserSettingClass(getContext()).setToken("") // 清空首选项
      AppStorage.setOrCreate(TOKEN_KEY, "") // 设置全局的token为空
      router.replaceUrl({
        url: 'pages/Login/Login' // 跳转到登录页
      })
      return Promise.reject(new Error("登录失效"))
    } else if (res.responseCode === 404) {
      // 删除token
      promptAction.showToast({ message: '请求地址错误' })
      return Promise.reject(new Error("请求地址错误"))
    } else {
      const result = JSON.parse(res.result as string) as ResponseData<T> // code(业务状态码) msg data  只有等于200的时候 才是成功的
      // 进一步判断业务状态码
      if (result.code === 200) {
        // 只有这个时刻才是成功的
        return result.data as T
      } else {
        promptAction.showToast({ message: result.msg })
        return Promise.reject(new Error(result.msg))
      }
    }
    //  res.result as string 要返回的结构
  } catch (error) {
    promptAction.showToast({ message: error.message })
    return Promise.reject(error)
  }
}

// 封装请求对象
export class Request {
  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data)
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
}