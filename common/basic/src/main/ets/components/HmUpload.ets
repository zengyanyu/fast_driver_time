import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { HmPreview } from '.';
import { ImageList } from '../viewmodels';
import { fileIo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { request } from '@kit.BasicServicesKit';
import { uploadImage } from '../api/upload';

@Preview
@Component
struct HmUpload {
  title: string = "上传信息"
  maxNumber: number = 3
  @Prop
  imgList: ImageList[] = [] // [{ url }]
  onListChange: (list: ImageList[]) => void = () => {
  }
  // 能否进行上传操作
  @Prop
  canUpload: boolean = true
  index: number = -1 // 记录当前点击的索引的值
  previewDialog: CustomDialogController = new CustomDialogController({
    builder: HmPreview({
      urls: this.imgList.map(item => item.url), // string []
      selectIndex: this.index
    }),
    customStyle: true
  })

  async selectImage() {
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    const result = await photoPicker.select({
      maxSelectNumber: this.maxNumber - this.imgList.length,
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE  // 只选择图片
    })
    if (result.photoUris.length) {
      // 赋值给imgList
      this.imgList = this.imgList.concat(result.photoUris.map(url => {
        return { url } as ImageList
      }))
      this.onListChange(this.imgList) // 传出去
      // 通知父组件
    }
  }

  build() {
    Column() {
      Text(this.title).fontSize(14).fontColor($r("app.color.text_secondary")).margin({
        top: 16,
        bottom: 16
      })
      Grid() {
        ForEach(this.imgList, (item: ImageList, index: number) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.url)
                .width("100%")
                .aspectRatio(1)
                .borderRadius(4)
              // 判断是否可以删除文件
              if (this.canUpload) {
                Image($r("app.media.ic_btn_delete"))
                  .width(30)
                  .aspectRatio(1)
                  .onClick(() => {
                    this.imgList.splice(index, 1) // 移除本组件数据
                    this.onListChange(this.imgList)
                  })
              }
            }

          }.onClick(() => {
            this.index = index // 记录当前索引
            this.previewDialog.open() // 打开弹层
          })
        })
        if (this.imgList.length < this.maxNumber) {
          // 只有数量未达到最大数量时才可以显示
          if (this.canUpload) {
            GridItem() {
              Row() {
                Image($r("app.media.ic_add_img")).width(30).height(30)
              }
              .width("100%")
              .aspectRatio(1)
              .backgroundColor('#F2F2F2')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
            }
            .onClick(() => {
              // 选择相册
              this.selectImage()
            })
          }
        }
      }
      .columnsGap(10)
      .columnsTemplate("1fr 1fr 1fr")
    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}

// 公共的上传方法
const UploadFile = (list: ImageList[]): Promise<ImageList[]> => {
  // 这里要实现组装参数的逻辑
  // 沙箱目录
  const fileParams: request.File[] = [];
  const saveDir = getContext().cacheDir; // cache目录
  list.forEach(item => {
    // item 要从相册到cache目录
    const file = fileIo.openSync(item.url, fileIo.OpenMode.READ_ONLY); // 得到相册文件
    // 生成一个唯一的文件名
    const uniqueName = util.generateRandomUUID() + ".jpg"; // 拼接地址
    fileIo.copyFileSync(file.fd, saveDir + "/" + uniqueName); // 将文本拷贝到唯一的路径
    fileParams.push({
      filename: uniqueName,
      type: 'jpg',
      uri: "internal://cache/" + uniqueName,
      name: 'file' // 上传接口的name值
    });
    fileIo.closeSync(file);
  });
  // 调用上传图像的接口uploadImage
  return uploadImage(getContext(), fileParams);
}

export { HmUpload, UploadFile }