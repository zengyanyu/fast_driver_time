@CustomDialog
@Component
export struct HmProgress {
  controller: CustomDialogController
  title: string = "加载中..."

  build() {
    Row({ space: 10 }) {
      Text(this.title)
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
      LoadingProgress()
        .width(20)
        .aspectRatio(1)
    }
    .justifyContent(FlexAlign.Center)
    .width(100)
    .height(40)

  }
}