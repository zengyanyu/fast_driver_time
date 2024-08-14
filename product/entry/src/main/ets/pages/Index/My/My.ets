import { HmCard, HmCardItem, HmProgress } from '@ohos/basic'
import { getUserInfoAPI, getUserTaskInfoAPI } from '../../../api';
import { UserInfo, UserInfoModel, UserTaskInfo, UserTaskInfoModel, UserTaskInfoParamsModel } from '../../../viewmodels';
import { promptAction, router } from '@kit.ArkUI';

// 我的组件
@Preview
@Component
struct My {
  @State
  userInfo: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Consume
  @Watch("getUserInfo")
  currentName: string
  // 请求参数
  queryTaskParams: UserTaskInfoParamsModel = new UserTaskInfoParamsModel({
    year: new Date().getFullYear().toString(), // 必须传值  不传值报错
    month: (new Date().getMonth() + 1).toString() // 必须传值  不传值报错
  })
  // 返回结构
  @State
  userTaskInfo: UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)
  loadingDialog: CustomDialogController = new CustomDialogController({
    builder: HmProgress({
      title: '努力加载中......'
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  // 初始化-只获取一次
  aboutToAppear(): void {
    // this.getUserInfo();
  }

  // 每次点击的时候,都获取一次
  // 获取用户信息
  async getUserInfo() {
    if (this.currentName === 'my') {
      // 开启
      this.loadingDialog.open();
      this.userInfo = await getUserInfoAPI();

      // 用户任务
      this.userTaskInfo = await getUserTaskInfoAPI(this.queryTaskParams)
      // 关闭
      this.loadingDialog.close();
    }
  }

  build() {
    Column() {
      // 基本信息
      Column() {
        Image(this.userInfo.avatar)
          .width(67)
          .height(67)
          .borderRadius(34.5)
          .backgroundColor($r('app.color.white'))
        Text(`司机${this.userInfo.name}`)
          .fontSize(18)
          .fontWeight(600)
          .lineHeight(25)
          .margin({
            top: 9,
            bottom: 9
          })
          .fontColor($r('app.color.white'))
        Text(`司机编号: ${this.userInfo.number}`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
        Text(`手机号: ${this.userInfo.phone}`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .margin({
            top: 10
          })
          .fontColor($r('app.color.white'))
      }
      .backgroundImage($r("app.media.bg_page_my"))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height(292)
      .margin({
        top: -2
      })

      // 本月任务
      Column() {
        Text("- 本月任务 -").fontSize(14).fontColor($r('app.color.text_secondary')).lineHeight(20)
        Row() {
          Column() {
            Text(this.userTaskInfo.taskAmounts?.toString())
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({
                bottom: 17
              })
            Text("任务总量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text(this.userTaskInfo.completedAmounts?.toString())
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("完成任务量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text(this.userTaskInfo.transportMileage?.toString())
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("运输里程(km)").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
        }.justifyContent(FlexAlign.SpaceBetween).width('100%').layoutWeight(1)
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .margin({
        left: 14.5,
        right: 14.5,
        top: -55,
        bottom: 15
      })
      .height(134)
      .padding({ top: 13.5, bottom: 13.5 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 信息列表
      // 下面的代码,可以正常显示
      HmCard() {
        HmCardItem({
          leftTitle: '车辆信息'
        })
        HmCardItem({
          leftTitle: '任务数据'
        })
        HmCardItem({
          leftTitle: '系统设置',
          showBottomBorder: false,
          onRightClick: () => {
            // promptAction.showToast({ message: '点击事件成功' })
            // 路由跳转
            router.pushUrl({
              url: 'pages/Setting/Setting'
            })
          }
        })
      }

      // 不能正常显示如下的代码
      // 错误信息:Error message:class constructor cannot called without 'new'
      // HmCard({
      //   HmCardFn: () => {
      //     HmCardItem({ leftTitle: 'xxx' })
      //   }
      // })

    }.width('100%').height('100%').backgroundColor($r('app.color.background_page')).borderRadius(8)
  }
}

export default My