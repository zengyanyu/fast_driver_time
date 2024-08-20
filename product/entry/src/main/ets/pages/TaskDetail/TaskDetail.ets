import { promptAction, router } from '@kit.ArkUI';
import { deliverAPI, getTaskDetailAPI, pickUpAPI } from '../../api';

import { HmNavBar, HmSkeleton, HmToggleCard, HmUpload, ImageList, UploadFile } from '@ohos/basic';
import { TaskDetailInfo, TaskDetailInfoModel } from '../../viewmodels/detail';
import { CommonRouterParams, DeliverParamsTypeModel, PickUpParamsModel } from '../../viewmodels';
import { TaskTypeEnum } from '../../viewmodels/task';
import { taskpool, util, worker } from '@kit.ArkTS';
import { PostParams } from '../../workers/UploadWorker';
import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';

@Entry
@Component
struct TaskDetail {
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params) {
      this.getTaskDetail(params.id as string)
    }
  }

  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetailAPI(id)
  }

  @Builder
  getBaseContentItem(item: BaseBuilderClass) {
    Row() {
      Text(item.title).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Row() {
        Text(item.value).fontSize(14).fontColor($r('app.color.text_secondary'))
        if (item.icon) {
          Image(item.icon).width(24).height(24)
        }
      }
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }

  // 获取基础信息
  @Builder
  getBaseContent() {
    Row() {
      Column() {
        Row() {
          Text("起").baseTextOneStyle()
          Text(this.taskDetailData.startAddress).baseTextTwoStyle()
        }.margin({ top: 21 })

        Row() {
          Text("止").baseTextOneStyle().backgroundColor($r('app.color.primary'))
          Text(this.taskDetailData.endAddress).baseTextTwoStyle()
        }.margin({ top: 14.5 })
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({
        right: 20
      })

      Column() {
        Image($r("app.media.ic_navigation")).width(22).height(22)
        Text("开始导航").fontSize(14).margin({ top: 10, bottom: 10 })
      }.justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top: 20
      })

    }.justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .width('100%')

    Divider().vertical(false).height(2)
      .color($r('app.color.background_divider')).margin({ left: 8, right: 8, top: 21 })
    this.getBaseContentItem({
      title: '任务编号',
      value: this.taskDetailData.transportTaskId
    })
    this.getBaseContentItem({
      title: '联系人',
      value: this.taskDetailData.startHandoverName
    })
    this.getBaseContentItem({
      title: '联系电话',
      value: this.taskDetailData.startHandoverPhone,
      icon: $r('app.media.ic_phone')
    })
    this.getBaseContentItem({
      title: '提货时间',
      value: this.taskDetailData.planDepartureTime
    })
    this.getBaseContentItem({
      title: '预计送达时间',
      value: this.taskDetailData.planArrivalTime
    })
  }

  // 司机信息
  @Builder
  getDriverContent() {
    Row() {
      Text(`车牌号`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.taskDetailData.driverId).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })

    Row() {
      Text(`司机姓名`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.taskDetailData.driverName).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }

  // 运输路线
  @Builder
  getTransLineContent() {
    Row() {
      Column() {
        Text(this.taskDetailData.startProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.taskDetailData.startCity).fontSize(14).lineHeight(22)
      }.width(50)

      Image($r("app.media.ic_right_arrow")).width(36).height(16)
      Column() {
        Text(this.taskDetailData.endProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.taskDetailData.endCity).fontSize(14).lineHeight(22)
      }.width(50)
    }.justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center).width('100%').padding({
      left: 60,
      right: 60
    })
  }

  // 底部按钮结构
  @Builder
  getBottomBtn() {
    //已完成不显示任何按钮
    Row() {
      if (this.taskDetailData.status === TaskTypeEnum.Waiting) {
        Button("延迟收货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Delay/DelayPage',
              params: {
                id: this.taskDetailData.id,
                oldTime: this.taskDetailData.planDepartureTime
              }
            })
          })
        Button("提货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .margin({ left: 13 })
          .enabled(this.getPickUpState())
          .onClick(() => {
            this.toPickUp()
          })
      } else if (this.taskDetailData.status === TaskTypeEnum.Line) {
        Button("上报异常", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125)
          .onClick(() => {
            // 跳转到上报异常页面
            router.pushUrl({
              url: 'pages/Exception/Exception',
              params: {
                id: this.taskDetailData.transportTaskId
              }
            })
          })
        Button("交货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .margin({ left: 13 })
          .enabled(this.getDeliverState())
          .onClick(() => {
            this.btnDeliver()
          })
      } else if (this.taskDetailData.status === TaskTypeEnum.Delivered) {
        Row() {
          Button("回车登记", { type: ButtonType.Capsule })
            .backgroundColor($r('app.color.primary'))
            .fontColor($r('app.color.white'))
            .height(50)
            .flexGrow(1)
            .margin({ left: 13 })
            .enabled(this.getDeliverState())
            .onClick(() => {
              router.pushUrl({
                url: 'pages/CarRecord/CarRecord',
                // 直接传递整个对象
                params: this.taskDetailData
                // params: {
                //   id: this.taskDetailData.id
                // }
              })
            })
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)

      }
    }
    .width('100%')
    .padding({ left: 15, right: 15 })
    .height(70)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.white'))
  }

  // 去提货
  async toPickUp() {
    const task1 = new taskpool.Task(dealImage,
      [...this.taskDetailData.cargoPictureList], getContext().cacheDir) // 子线程
    const task2 =
      new taskpool.Task(dealImage, [...this.taskDetailData.cargoPickUpPictureList],
        getContext().cacheDir) // 子线程
    const result1 = await taskpool.execute(task1) // 执行任务
    const result2 = await taskpool.execute(task2) // 执行任务
    const result = await Promise.all([UploadFile(result1 as ImageList[]),
      UploadFile(result2 as ImageList[])])
    // const result = await Promise.all([UploadFile(this.taskDetailData.cargoPictureList),
    //   UploadFile(this.taskDetailData.cargoPickUpPictureList)])

    // const cargoPictureList = await UploadFile(this.taskDetailData.cargoPictureList) // 上传之后的地址
    // const cargoPickUpPictureList = await UploadFile(this.taskDetailData.cargoPickUpPictureList) // 上传之后的地址
    // 提货操作
    await pickUpAPI(new PickUpParamsModel({
      id: this.taskDetailData.id,
      cargoPictureList: result[0],
      cargoPickUpPictureList: result[1]
    }))
    promptAction.showToast({ message: '提货成功' })
    // 重新拉取数据
    this.getTaskDetail(this.taskDetailData.id)
  }

  // 交货操作
  async btnDeliver() {
    // 可以对图片进行压缩->耗时任务->多线程
    const worker1 = new worker.ThreadWorker('entry/ets/workers/UploadWorker.ets'); // 子线程1
    const worker2 = new worker.ThreadWorker('entry/ets/workers/UploadWorker.ets'); // 子线程2
    let certificatePictureList: ImageList[] = []
    let deliverPictureList: ImageList[] = []
    // 线程1的消息
    worker1.onmessage = (event) => {
      const res = event.data as PostParams
      certificatePictureList = res.images
      checkFile()
    }
    // 线程2的消息
    worker2.onmessage = (event) => {
      const res = event.data as PostParams
      // res.images // 最终要的结构
      deliverPictureList = res.images
      checkFile()
    }

    worker1.postMessage({
      // 被State修饰的数据不是普通结构,所以这里需要使用浅拷贝,使用三个点...
      images: [...this.taskDetailData.certificatePictureList],
      // 多线程没有上下文,getContext返回undefined
      filePath: getContext().cacheDir
    })
    worker2.postMessage({
      // 被State修饰的数据不是普通结构,所以这里需要使用浅拷贝,使用三个点...
      images: [...this.taskDetailData.deliverPictureList],
      // 多线程没有上下文,getContext返回undefined
      filePath: getContext().cacheDir
    })

    const checkFile = async () => {
      if (certificatePictureList.length && deliverPictureList.length) {
        // 图片压缩完成
        const result = await Promise.all([UploadFile(certificatePictureList),
          UploadFile(deliverPictureList)])

        await deliverAPI(new DeliverParamsTypeModel({
          id: this.taskDetailData.id,
          certificatePictureList: result[0],
          deliverPictureList: result[1],
        }))
        promptAction.showToast({ message: '交货成功' })
        this.getTaskDetail(this.taskDetailData.id) // 重新拉取数据
      }
    }


    // const result = await Promise.all([UploadFile(this.taskDetailData.certificatePictureList),
    //   UploadFile(this.taskDetailData.deliverPictureList)])
    //
    // await deliverAPI(new DeliverParamsTypeModel({
    //   id: this.taskDetailData.id,
    //   certificatePictureList: result[0],
    //   deliverPictureList: result[1],
    // }))
    // promptAction.showToast({ message: '交货成功' })
    // this.getTaskDetail(this.taskDetailData.id) // 重新拉取数据
  }

  // 判断交货按钮是否可点
  getDeliverState() {
    // 判断提货凭证 和提货货品照片都有值才可以
    return this.taskDetailData.certificatePictureList?.length > 0 &&
      this.taskDetailData.deliverPictureList?.length > 0
      && this.taskDetailData.certificatePictureList?.every(item =>!!item)
      && this.taskDetailData.deliverPictureList?.every(item =>!!item)
  }

  // 控制提货的操作按钮,是否可用
  getPickUpState() {
    return this.taskDetailData.cargoPictureList?.length > 0 &&
      this.taskDetailData.cargoPickUpPictureList?.length > 0
      // 表示集合中没有空值,使用数组中的every判断;
      && this.taskDetailData.cargoPictureList?.every(item =>!!item)
      && this.taskDetailData.cargoPickUpPictureList?.every(item =>!!item)
  }

  // 提货信息
  @Builder
  getPickUpContent() {
    HmUpload({
      title: '请拍照上传回单凭证',
      imgList: this.taskDetailData.cargoPickUpPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.cargoPickUpPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting
    })
    HmUpload({
      title: '请拍照上传货品照片',
      imgList: this.taskDetailData.cargoPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.cargoPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting
    })
  }

  // 送货
  @Builder
  getDeliverContent() {
    HmUpload({
      title: '请拍照上传回单凭证',
      imgList: this.taskDetailData.certificatePictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.certificatePictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line
    })
    HmUpload({
      title: '请拍照上传货品照片',
      imgList: this.taskDetailData.deliverPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.deliverPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line
    })
  }

  build() {
    Column() {
      HmNavBar({ title: '任务详情' })

      Scroll() {
        // 只能放置一个组件
        if (this.taskDetailData.id) {
          Column() {
            HmToggleCard({ title: '基本信息' }) {
              this.getBaseContent()
            }

            HmToggleCard({ title: '车辆司机信息' }) {
              this.getDriverContent()
            }

            HmToggleCard({ title: '运输路线' }) {
              this.getTransLineContent()
            }

            if (this.taskDetailData.status === TaskTypeEnum.Waiting ||
              this.taskDetailData.status === TaskTypeEnum.Delivered
            ) {
              HmToggleCard({ title: '提货信息' }) {
                this.getPickUpContent()
              }
            }
            if (this.taskDetailData.status === TaskTypeEnum.Line ||
              this.taskDetailData.status === TaskTypeEnum.Delivered) {
              HmToggleCard({ title: '交货信息' }) {
                this.getDeliverContent()
              }
            }
          }
        } else {
          HmSkeleton()
        }
      }
      .padding({
        bottom: 120
      })
      .layoutWeight(1) // 占满剩余空间

      // 放置底部按钮
      this.getBottomBtn()
    }
    .backgroundColor($r("app.color.background_page"))
    .height('100%')
    .width('100%')
  }
}

@Extend(Text)
function baseTextOneStyle() {
  .fontSize(12)
  .fontColor($r('app.color.white'))
  .backgroundColor($r('app.color.text_primary'))
  .width(22)
  .height(22)
  .borderRadius(11)
  .textAlign(TextAlign.Center)
}

@Extend(Text)
function baseTextTwoStyle() {
  .margin({ left: 11.5 }).fontColor($r('app.color.text_secondary')).fontSize(14).lineHeight(20)
}

class BaseBuilderClass {
  title: string = ""
  value: string = ""
  icon?: ResourceStr = ""
}

// taskPool 不允许把耗时的任务没有结束就返回
// 不要一个没有结果的东西
// taskPool 只能执行Concurrent修饰符修饰的函数
@Concurrent
async function dealImage(images: ImageList[], path: string) {
  const imagePackerAPI = image.createImagePacker() // 创建图片压缩API
  let packOpts: image.PackingOption = { format: "image/jpeg", quality: 20 };
  let arr: ImageList[] = []
  while (images.length) {
    const obj = images.pop() // 每次取一条
    const sourceFile = fileIo.openSync(obj?.url, fileIo.OpenMode.READ_ONLY) // 打开来源文件
    // 对来源文件进行压缩
    const newFileName = path + "/" + util.generateRandomUUID() + ".jpg"
    const targetFile = fileIo.openSync(newFileName, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    // 目标文件的fd
    await imagePackerAPI.packToFile(image.createImageSource(sourceFile.fd), targetFile.fd, packOpts)
    fileIo.closeSync(sourceFile.fd) // 关闭来源文件
    fileIo.closeSync(targetFile.fd) // 关闭目标文件
    arr.push({
      url: newFileName
    })
  }
  return arr
}