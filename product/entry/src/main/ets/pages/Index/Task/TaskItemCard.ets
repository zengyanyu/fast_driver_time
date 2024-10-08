import { promptAction, router } from '@kit.ArkUI'
import { TaskInfoItem, TaskInfoItemModel, TaskTypeEnum } from '../../../viewmodels/task'

@Preview
@Component
struct TaskItemCard {
  item: TaskInfoItemModel = new TaskInfoItemModel({} as TaskInfoItem)

  getBtnEnable() {
    if (this.item.enablePickUp) {
      return true
    }
    switch (parseInt(this.item.status)) {
      case TaskTypeEnum.Line:
      case TaskTypeEnum.Delivered:
        return true
      default:
        return false
    }
  }

  getBtnText() {
    switch (parseInt(this.item.status)) {
      case TaskTypeEnum.Waiting:
        return "提货"
      case TaskTypeEnum.Line:
        return "交货"
      case TaskTypeEnum.Delivered:
        return "回车登记"
      default:
        return ""
    }
  }

  // 去提货
  toPickUp() {
    promptAction.showToast({ message: this.item.id })
    router.pushUrl({
      url: 'pages/TaskDetail/TaskDetail',
      params: {
        // 传递id到详情页
        id: this.item.id
      }
    })
  }

  build() {
    Column() {
      Row() {
        Text(`任务编号：${this.item.transportTaskId}`)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
          .fontWeight(500)
          .lineHeight(22)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')

      Row() {
        Text("起")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.text_primary"))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.item.startAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 21 }).width('100%')
      .padding({
        right: 10
      })

      Row() {
        Text("止")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r('app.color.primary'))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.item.endAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 14.5 }).width('100%')
      .padding({
        right: 10
      })


      Divider()
        .vertical(true)
        .height(2)
        .color($r('app.color.background_divider'))
        .opacity(0.6)
        .margin({ left: 8, right: 8, top: 21 })
      Row() {
        Column() {
          Text('提货时间').fontSize(14).fontColor($r('app.color.text_secondary'))
          Text(this.item.planDepartureTime).fontSize(14).fontColor($r('app.color.text_secondary')).margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button(this.getBtnText(), { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .fontColor($r("app.color.white"))
          .fontSize(14)
          .height(32)
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.toPickUp()
          })

      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .margin({ left: 15, right: 15, top: 15 })
    .padding({
      left: 19.5,
      right: 19.5,
      bottom: 18.5,
      top: 18.5
    })
    .borderRadius(10)
    .backgroundColor($r('app.color.white'))

  }
}

export default TaskItemCard