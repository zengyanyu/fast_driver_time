@Component
export struct HmCheckBox {
  title: string = "左侧内容"
  confirmText: string = "是"
  cancelText: string = "否"
  @Prop
  value: boolean = false // 当前的值 true/左侧选中  false 右侧选中
  checkChange: (value: boolean) => void = () => {
  }

  build() {
    Row() {
      Row() {
        Text(this.title)
          .fontSize(14)
          .fontColor($r("app.color.text_primary"))

        Row() {
          Row() {
            Image(this.value ? $r("app.media.ic_radio_true") : $r("app.media.ic_radio_false"))
              .width(32)
              .aspectRatio(1)
            Text(this.confirmText)
          }
          .onClick(() => {
            this.value = true
            this.checkChange(this.value)
          })

          Row() {
            Image(!this.value ? $r("app.media.ic_radio_true") : $r("app.media.ic_radio_false"))
              .width(32)
              .aspectRatio(1)
            Text(this.cancelText)
          }
          .onClick(() => {
            this.value = false
            this.checkChange(this.value)
          })
        }

      }
      .backgroundColor($r("app.color.white"))
      .width("100%")
      .borderRadius(10)
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 15,
        right: 15
      })
    }
    .width("100%")
    .padding({
      left: 15,
      right: 15
    })
    .margin({
      top: 15
    })
  }
}