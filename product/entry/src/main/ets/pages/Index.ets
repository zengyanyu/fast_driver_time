@Entry
@Component
struct Index {

  build() {
    Column(){
      Text('小时达项目')
        .fontSize(40)
        .backgroundColor(Color.White)
        .fontWeight(FontWeight.Bold)
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.start'))
    .backgroundImageSize({
      width:'100%',
      height:'100%'
    })
    .padding(20)
  }
}