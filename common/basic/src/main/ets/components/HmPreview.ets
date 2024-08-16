@CustomDialog
@Component
struct HmPreview {
  controller: CustomDialogController
  urls: string[] = [] // 图片列表
  selectIndex: number = -1 // 从第几张看

  build() {
    Swiper() {
      ForEach(this.urls, (url: string) => {
        Image(url)
          .width("100%")
          .onClick(() => {
            this.controller.close() // 关闭弹层
          })
      })
    }
    .index(this.selectIndex)
    .indicator(false)
    .backgroundColor($r("app.color.black"))
    .width("100%")
    .height("100%")
  }
}

export { HmPreview }