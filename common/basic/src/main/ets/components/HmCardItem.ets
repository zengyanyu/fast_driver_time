@Component
struct HmCardItem {
  // 左标题
  leftTitle: string = ''
  // 右边内容
  @Prop
  rightValue: string = ''
  // 是否显示右箭头
  showIcon: boolean = true
  // 是否显示下划线
  showBottomBorder: boolean = true

  build() {
    Column() {
      Row() {
        Text(this.leftTitle)
          .fontWeight(400)
          .fontColor($r("app.color.text_primary"))

        Row() {
          if (this.rightValue) {
            Text(this.rightValue)
              .fontColor($r("app.color.text_secondary"))
              .fontSize(14)
              .fontWeight(400)
          }
          if (this.showIcon) {
            Image($r('app.media.ic_btn_more'))
              .width(24)
              .aspectRatio(1)
          }
        }
      }.width('100%')
      .height(60)
      .border({
        color: $r('app.color.background_divider'),
        width: {
          bottom: this.showBottomBorder ? 1 : 0
        }
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width("100%")
  }
}

export { HmCardItem }