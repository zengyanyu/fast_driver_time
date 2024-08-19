@Preview
@CustomDialog
@Component
export struct HmSelectCard {
  controller: CustomDialogController
  title: string = "请选择" // 显示标题
  showClose: boolean = true // 显示关闭按钮
  showButton: boolean = true // 显示底部按钮
  buttonText: string = "确定" // 底部按钮文本
  confirm: () => void = () => {
  }
  @BuilderParam
  cardContent: () => void

  build() {
    Column() {
      Row() {
        Text(this.title).fontSize(16).fontColor($r('app.color.text_primary'))
        Image($r("app.media.ic_btn_close")).width(13).height(13)
          .visibility(this.showClose ? Visibility.Visible : Visibility.Hidden)
          .onClick(() => {
            this.controller.close()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(60)
      .borderRadius({
        topLeft: 16,
        topRight: 16
      })

      // 渲染内容
      if (this.cardContent) {
        this.cardContent()
      }

      Row() {
        if (this.showButton) {
          Button(this.buttonText, { type: ButtonType.Capsule })
            .width(200)
            .backgroundColor($r('app.color.primary'))
            .height(45)
            .onClick(() => {
              this.confirm()
            })
        }
      }.width('100%').justifyContent(FlexAlign.Center)
    }
    .backgroundColor($r('app.color.white'))
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 21.36,
      right: 21.36
    })
    .padding({
      left: 15,
      right: 10,
      bottom: 20
    })
    // 设置左上角,右上角为圆角
    .borderRadius({
      topLeft: 10,
      topRight: 10
    })
  }
}
