import { request } from '@kit.BasicServicesKit'
import { TOKEN_KEY } from '../constants/setting'
import { BASE_URL } from '../constants/url'
import { JSON } from '@kit.ArkTS'
import { ImageList, ResponseData } from '../viewmodels'

// 上传图像
export const uploadImage = (context: Context, files: request.File[]) => {
  return new Promise<ImageList[]>(async (resolve, reject) => {
    try {
      let arr: ImageList[] = []
      const task = await request.uploadFile(context, {
        url: BASE_URL + '/files/imageUpload',
        method: 'POST',
        header: {
          Authorization: AppStorage.get(TOKEN_KEY) || "",
          "Content-Type": 'multipart/form-data'
        },
        files: files,
        data: []
      })
      task.on("progress", () => {

      })
      // 一次次进来 传完一个 给一个的数据
      task.on("headerReceive", (header) => {
        if (header["body"]) {
          const res = JSON.parse(header["body"]) as ResponseData<string>
          if (res.code === 200) {
            arr.push({
              url: res.data as string
            })
          }
        }
      })
      // 失败告诉你
      task.on("fail", () => {
        AlertDialog.show({ message: '上传失败：' })
        reject(new Error("上传失败"))
      })
      task.on("complete", () => {
        // 上传完成
        resolve(arr)
      })
      // 任务创建成功 但是未必上传成功
    } catch (error) {
      AlertDialog.show({ message: '上传失败：' + error.message })
      reject(error)
    }
  })
}