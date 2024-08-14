import { HmCard, HmCardItem, HmConfirm, HmNavBar, TOKEN_KEY, UserSettingClass } from '@ohos/basic'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct Setting {
  dialog: CustomDialogController = new CustomDialogController({
    builder: HmConfirm({
      message: '确定要退出登录吗?'
    , buttonList: [{
        text: '取消'
      }, {
        text: '退出',
        fontColor: $r("app.color.primary"),
        action: () => {
          this.logout() // 退出
        }
      }]
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  // 退出操作
  logout() {
    new UserSettingClass(getContext()).setToken("")
    AppStorage.setOrCreate(TOKEN_KEY, "")
    // 跳转到登录页面
    router.replaceUrl({
      url: 'pages/Login/Login'
    })
  }

  build() {
    Column() {
      HmNavBar({
        title: '系统设置'
      })
      HmCard() {
        HmCardItem({ leftTitle: '绑定手机' })
        HmCardItem({ leftTitle: '修改密码' })
        HmCardItem({ leftTitle: '消息通知设置' })
        HmCardItem({ leftTitle: '清理缓存', showBottomBorder: false })
      }

      Row() {
        Button("退出")
          .type(ButtonType.Normal)
          .backgroundColor($r("app.color.white"))
          .fontColor($r('app.color.text_primary'))
          .width('100%')
          .borderRadius(8)
          .height(60)
      }.width('100%')
      .padding({
        left: 15,
        right: 15
      })
      .margin({
        top: 20
      })
      .onClick(() => {
        // 退出登录操作
        // promptAction.showToast({ message: '退出登录操作' })
        this.dialog.open();
      })
    }
    .height('100%')
    .width('100%').backgroundColor($r('app.color.background_page'))
  }
}