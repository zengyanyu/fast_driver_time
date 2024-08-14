import { router } from '@kit.ArkUI'

@Preview
@Component
export struct HmNavBar {
  title: string = "测试个人中心"
  showBackIcon: boolean = true // 是否显示返回图标

  build() {
    Stack({ alignContent: Alignment.Start }) {
      // 标题
      if (this.title) {
        Row() {
          Text(this.title)
            .fontColor($r("app.color.text_primary"))
            .fontSize(18)
            .fontWeight(600)
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
        .height(50)

      }
      // 图标
      if (this.showBackIcon) {
        Row() {
          Image($r("app.media.ic_btn_nav_back"))
            .width(44)
            .aspectRatio(1)
        }
        .onClick(() => {
          // 返回
          router.back()
        })
      }
    }
    .width("100%")
    .height(50)
    .backgroundColor($r("app.color.white"))
  }
}

