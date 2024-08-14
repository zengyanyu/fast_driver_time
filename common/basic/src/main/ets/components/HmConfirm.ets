@CustomDialog
@Component
export struct HmConfirm {
  controller: CustomDialogController
  message: string = ''
  buttonList: HmConfirmButton [] = [{
    text: '确定',
    fontSize: 14,
    fontColor: $r("app.color.primary")
  }]

  build() {
    Column() {
      // 文本
      Row() {
        Text(this.message)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
      }
      .justifyContent(FlexAlign.Center)
      .height(88)
      .width("100%")
      .border({
        color: $r("app.color.background_divider"),
        width: {
          bottom: 1
        }
      })

      // 按钮
      Row() {
        ForEach(this.buttonList, (item: HmConfirmButton, index: number) => {
          Text(item.text)
            .fontSize(item.fontSize || 16)
            .fontColor(item.fontColor || $r("app.color.text_secondary"))
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
            .height("100%")
            .border({
              color: $r("app.color.background_divider"),
              width: {
                // 判断最后一个按钮右边是否放border
                right: (index !== (this.buttonList.length - 1) && this.buttonList.length > 1) ? 1 : 0
              }
            })
            .onClick(async () => {
              if (item.action) {
                await item.action() // 执行逻辑
              }
              this.controller.close() // 等别人做完事 再关闭
            })
        })
      }
      .width("100%")
      .height(49)
    }
    .borderRadius(12)
    .width(278)
    .backgroundColor($r("app.color.white"))
  }
}

export class HmConfirmButton {
  text: string = "" // 文本
  fontSize?: number = 16 // 标题大小
  fontColor?: ResourceStr = $r("app.color.text_secondary")
  action?: () => void
}