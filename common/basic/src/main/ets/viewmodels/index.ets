export * from './Advert'

export * from './tabs'

export * from './common'

// 泛型工具
export class ResponseData<T> {
  code: number = 0
  msg: string = ""
  data: T | null = null
  // data?: T
}