import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { defaultAd, UserSettingClass } from '@ohos/basic/src/main/ets/utils/setting';
import { AdvertClass } from '@ohos/basic';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // 检查是否有广告
    const setting = new UserSettingClass(this.context)
    //
    const ad = await new Promise<AdvertClass>((resolve) => {
      setTimeout(() => {
        resolve(defaultAd) // 广告信息
      }, 500)
      // resolve()
    })
    // 通过模拟请求拿到广告信息
    // 写入首选项
    await setting.setUserAd(ad)
    
    if (ad.showAd) { // 显示广告
      const win = await windowStage.createSubWindow("ad_window");
      await win.showWindow(); // 展示窗口
      win.setUIContent('pages/Start/Start') // 设置窗口内容
    }
    // 判断是否有TOKEN
    const token = setting.getToken()
    if (token) {
      // 需要判断一下有没有token
      windowStage.loadContent("pages/Index/Index") // 正常加载主页
    } else {
      windowStage.loadContent("pages/Login/Login") // 跳转到登录
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
