// 后续上传 basic模块也需要类型
export interface ImageList {
  /** 图片url */
  url: string;
}

export class ImageListModel implements ImageList {
  url: string = ''

  constructor(model: ImageList) {
    this.url = model.url
  }
}