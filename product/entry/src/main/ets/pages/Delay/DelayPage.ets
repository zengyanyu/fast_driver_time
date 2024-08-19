import { CommonRouterParams, DelayParamsType, DelayParamsTypeModel } from '../../viewmodels'
import { promptAction, router } from '@kit.ArkUI'
import { HmCardItem, HmNavBar } from '@ohos/basic'
import dayjs from 'dayjs'
import { delayAPI } from '../../api'

@Entry
@Component
struct DelayPage {
  @State
  delayForm: DelayParamsTypeModel = new DelayParamsTypeModel({} as DelayParamsType)
  @State
  oldTime: string = ""

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id && params.oldTime) {
      this.delayForm.id = params.id
      this.oldTime = params.oldTime
    }
  }

  // 延迟提货操作
  async delayOperation() {
    try {
      await delayAPI(this.delayForm)
      promptAction.showToast({ message: '延迟提货操作成功' })
    } catch (error) {
      promptAction.showToast({ message: '延迟提货操作失败' + error.message })
    }
  }

  build() {
    Column() {
      HmNavBar({
        title: '延迟提货'
      })
      HmCardItem({ leftTitle: '原定时间', rightValue: this.oldTime, showIcon: false })
      HmCardItem({
        leftTitle: '延迟时间', rightValue: this.delayForm.delayTime || '',
        onRightClick: () => {
          DatePickerDialog.show({
            showTime: true, // 显示时间
            useMilitaryTime: true, // 使用24小时制
            alignment: DialogAlignment.Bottom, // 显示的位置在最下方
            onDateAccept: (value) => {
              // 选择的时间,返回函数
              this.delayForm.delayTime = dayjs(value).format("YYYY-MM-DD HH:mm")
            }
          })
        }
      })
      TextArea({
        placeholder: '请输入延迟提货原因',
        text: this.delayForm.delayReason
      })
        .height(130)
        .borderRadius(8)
        .placeholderColor($r('app.color.text_secondary'))
        .fontSize(14)
        .maxLength(50)// 最长显示50个字符
        .onChange((value) => {
          // 双向绑定
          this.delayForm.delayReason = value
        })
        .showCounter(true) // 显示总字数

      Row() {
        Button("提交")
          .height(50)
          .width(207)
          .backgroundColor($r('app.color.primary'))
          .onClick(() => {
            // 延迟提货操作
            this.delayOperation()
          })
      }
      .position({
        y: '100%'
      })
      .height(70)
      .translate({
        y: -70
      })
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%')
    .width('100%')
    .padding(20)
  }
}