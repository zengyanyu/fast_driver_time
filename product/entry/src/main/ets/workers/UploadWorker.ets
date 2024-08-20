import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, util, worker } from '@kit.ArkTS';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { ImageList } from '@ohos/basic';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = async (e: MessageEvents) => {
  const params = e.data as PostParams
  const imagePackerApi = image.createImagePacker(); // 编码工具
  let packOpts: image.PackingOption = { format: "image/jpeg", quality: 20 };
  const arr: ImageList[] = []
  while (params.images.length) {
    try {
      // 只要有长度就循环
      const obj = params.images.pop() // 每次弹出一项
      // 打开这个文件
      const sourceFile = fileIo.openSync(obj?.url, fileIo.OpenMode.READ_ONLY) // 源文件
      // params.filePath = '/data/storage/el2/base/haps/entry/cache'
      const newFilePath = params.filePath + "/" + util.generateRandomUUID() + ".jpg" // 目标路径
      // 进行压缩
      const targetFile = fileIo.openSync(newFilePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
      // 目标文件的文件描述
      await imagePackerApi.packToFile(image.createImageSource(sourceFile.fd),
        targetFile.fd,
        packOpts
      ) // 压缩并存储到一个文件
      // 释放资源
      fileIo.closeSync(sourceFile.fd)
      fileIo.closeSync(targetFile.fd)
      arr.push({
        url: newFilePath // 最终的地址
      })
    } catch (error) {
      console.log(error.message)
      // 多线程不允许任何弹窗和UI操作
    }
  }
  // 发消息
  workerPort.postMessage({
    images: arr
  })
  workerPort.close() // 自毁子线程
}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}

export class PostParams {
  images: ImageList[] = []
  filePath: string = ""
}