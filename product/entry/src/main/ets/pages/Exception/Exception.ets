import { HmCard, HmCardItem, HmNavBar, HmSelectCard, HmUpload, ImageList } from '@ohos/basic'
import dayjs from 'dayjs'
import { promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams, ExceptionParamsType, ExceptionParamsTypeModel } from '../../viewmodels'
import { exportExceptionAPI } from '../../api'

@Entry
@Component
struct Exception {
  @State
  exceptionForm: ExceptionParamsTypeModel = new ExceptionParamsTypeModel({} as ExceptionParamsType)
  @State
  exceptErrorList: string[] =
    ["发动机启动困难", "不着车、漏油", "照明失灵", "有异常响动", "排烟异常、温度异常", "其他问题"]
  @State
  selectIndex: number = 0 // 默认选中第0个
  typeDialog: CustomDialogController = new CustomDialogController({
    builder: HmSelectCard({
      cardContent: () => {
        this.getCardContent()
      },
      confirm: () => {
        this.exceptionForm.exceptionType = this.exceptErrorList[this.selectIndex]
        this.typeDialog.close()
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.exceptionForm.transportTaskId = params.id
    }
  }

  onPageShow(): void {
    const params = router.getParams() as object
    if (params && params["location"]) {
      this.exceptionForm.exceptionPlace = params["location"] as string
    }
  }

  // 获取单选项
  @Builder
  getSingleItem(item: string, index: number) {
    Row() {
      Text(item).fontSize(14).fontWeight(400).fontColor($r('app.color.text_primary'))
      Row() {
        Image($r(`app.media.ic_check_${this.selectIndex === index}`))
          .width(32)
          .height(32)
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({
      width: {
        bottom: this.exceptErrorList.length === (index + 1) ? 0 : 1
      },
      color: $r('app.color.background_divider')
    })
    .width('100%')
    .height(60)
    .onClick(() => {
      this.selectIndex = index
    })
    .padding({
      bottom: 10
    })
  }

  // 异常类型_选择卡片
  @Builder
  getCardContent() {
    ForEach(this.exceptErrorList, (item: string, index: number) => {
      this.getSingleItem(item, index)
    })
  }

  // 上报异常
  async reportException() {
    // 创建对象
    try {
      // 地图接口没用,这里直接给上报异常位置赋值
      this.exceptionForm.exceptionPlace = '北京市'
      await exportExceptionAPI(this.exceptionForm);
      // 上报异常成功
      promptAction.showToast({ message: '上报异常成功' })
    } catch (error) {
      promptAction.showToast({ message: '上报异常失败,异常信息' + error.message })
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '上报异常' })

      HmCard() {
        HmCardItem({
          leftTitle: '异常时间',
          rightValue: this.exceptionForm.exceptionTime || '请选择',
          onRightClick: () => {
            DatePickerDialog.show({
              showTime: true, // 显示时间
              useMilitaryTime: true, // 使用24小时制
              alignment: DialogAlignment.Bottom, // 显示的位置在最下方
              onDateAccept: (value) => {
                // 选择的时间,返回函数
                this.exceptionForm.exceptionTime = dayjs(value).format("YYYY-MM-DD HH:mm")
              }
            })
          }
        })
        HmCardItem({
          leftTitle: '上报位置',
          rightValue: this.exceptionForm.exceptionPlace || '请选择',
          onRightClick: () => {
            router.pushUrl({
              url: 'pages/SelectLocation/SelectLocation'
            })
          }
        })
        HmCardItem({
          leftTitle: '异常类型',
          rightValue: this.exceptionForm.exceptionType || '请选择',
          onRightClick: () => {
            this.typeDialog.open()
          }
        })
        HmCardItem({
          leftTitle: '异常描述',
          rightValue: '',
          showIcon: false,
          showBottomBorder: false
        })
        TextArea({
          placeholder: '请输入异常描述',
          text: this.exceptionForm.exceptionDescribe
        })
          .height(130)
          .borderRadius(8)
          .placeholderColor($r('app.color.text_secondary'))
          .fontSize(14)
          .maxLength(50)
          .onChange((value) => {
            this.exceptionForm.exceptionDescribe = value
          })
          .showCounter(true)
        Row().height(20)
      }

      HmCard() {
        HmUpload({
          title: '上传图片(最多6张)', maxNumber: 6,
          onListChange: (list: ImageList[]) => {
            this.exceptionForm.exceptionImagesList = list
          },
        })
      }

      Row() {
        Button("提交")
          .height(50)
          .width(207)
          .backgroundColor($r('app.color.primary'))
          .onClick(() => {
            // 上报异常
            this.reportException()
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
    .backgroundColor($r("app.color.background_page"))
  }
}