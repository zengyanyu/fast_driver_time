import { HmCheckBox, HmNavBar, HmCard, HmCardItem, HmProgress } from '@ohos/basic'
import { promptAction, router } from '@kit.ArkUI'
import { carRecordAPI, getTaskDetailAPI } from '../../api'
import dayjs from 'dayjs'
import { TaskDetailInfo, TaskDetailInfoModel } from '../../viewmodels/detail'
import { CarRecordType, CarRecordTypeModel } from '../../viewmodels/car_record'

@Entry
@Component
struct CarRecord {
  loading: CustomDialogController = new CustomDialogController({
    builder: HmProgress({ title: '回车登记中' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State
  carRecord: CarRecordTypeModel = new CarRecordTypeModel({} as CarRecordType)

  aboutToAppear(): void {
    const params = router.getParams() as TaskDetailInfoModel
    if (params) {
      this.taskDetailData = params
      // this.getTaskDetail(params.id as string)
    }
  }

  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetailAPI(id)
  }

  async btnCarRecord() {
    if (!this.carRecord.endTime) {
      promptAction.showToast({ message: '请选择回车时间' })
      return
    }
    // 从上一个页面传过来的时间 赋值上去
    this.carRecord.startTime = this.taskDetailData.actualDepartureTime
    this.carRecord.id = this.taskDetailData.transportTaskId // 最重要的事情
    await carRecordAPI(this.carRecord)
    promptAction.showToast({ message: '回车登记成功' })
    // 一个业务走完 下一个业务 要去主页
    router.clear() // 清空路由栈
    // 重新开始下一个任务
    router.replaceUrl({
      url: 'pages/Index/Index'
    })
  }

  build() {
    Column() {
      HmNavBar({ title: '回车登记' })
      Scroll() {
        Column() {
          HmCard() {
            HmCardItem({
              leftTitle: '出车时间',
              rightValue: this.taskDetailData.actualDepartureTime || "",
              showIcon: false
            })
            HmCardItem({
              leftTitle: '回车时间',
              rightValue: this.carRecord.endTime || '请选择',
              showBottomBorder: false,
              onRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  alignment: DialogAlignment.Bottom,
                  onDateAccept: (date) => {
                    // 结束时间赋值
                    this.carRecord.endTime = dayjs(date).format("YYYY-MM-DD HH:mm:ss")

                  }
                })
              }
            })
          }

          HmCheckBox({
            title: '车辆违章', value: !!this.carRecord.isBreakRules, checkChange: (value) => {
              this.carRecord.isBreakRules = value
            }
          })
          HmCheckBox({
            title: '车辆故障', value: !!this.carRecord.isFault, checkChange: (value) => {
              this.carRecord.isFault = value

            }
          })
          HmCheckBox({
            title: '车辆事故', value: !!this.carRecord.isAccident, checkChange: (value) => {
              this.carRecord.isAccident = value

            }
          })
        }
        .height("100%")
      }
      .layoutWeight(1)

      Row() {
        Button("交车")
          .height(50)
          .width("100%")
          .backgroundColor($r("app.color.primary"))
          .onClick(() => {
            this.btnCarRecord()
          })
      }
      .alignItems(VerticalAlign.Top)
      .backgroundColor($r("app.color.white"))
      .padding({
        top: 10,
        left: 20,
        right: 20
      })
      .height(70)

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}