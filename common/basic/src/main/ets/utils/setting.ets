import { preferences } from '@kit.ArkData'
import { TOKEN_KEY, USER_SETTING, USER_SETTING_AD } from '../constants'
import { AdvertClass } from '../viewmodels'

// 默认广告的参数
export const defaultAd: AdvertClass = {
  showAd: true, // 显示广告
  adTime: 5, // 广告时长
  adUrl: '', // 广告链接
  adImg: $r("app.media.start")
}

export class UserSettingClass {
  // 首选项的读取和设置
  context?: Context // 上下文的属性
  constructor(ctx: Context) {
    this.context = ctx
  }

  // 获取仓库
  getStore() {
    return preferences.getPreferencesSync(this.context!, {
      name: USER_SETTING
    })
  }

  // 读写首选项的方法
  getUserAd() {
    const store = this.getStore()
    // return (JSON.parse(store.getSync(USER_SETTING_AD, JSON.stringify(defaultAd)) as string)) as AdvertClass
    return store.getSync(USER_SETTING_AD, defaultAd) as AdvertClass
    // key - value(string  boolean number)
    // object 一会测试一下
  }

  // 设置用户广告
  async setUserAd(ad: AdvertClass) {
    const store = this.getStore()
    // store.putSync(USER_SETTING_AD, JSON.stringify(ad))
    store.putSync(USER_SETTING_AD, ad)
    // 写入首选项
    await store.flush()
  }

  getToken() {
    const store = this.getStore()
    return store.getSync(TOKEN_KEY, '') as string
  }

  async setToken(token: string) {
    const store = this.getStore()
    store.putSync(TOKEN_KEY, token)
    // 刷新
    await store.flush();
  }
}
