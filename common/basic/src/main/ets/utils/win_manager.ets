// 如何封装一个全局的弹层
import { display, window } from '@kit.ArkUI'

export class WinManager {
  public ctx?: Context // 公共变量 需要在外面赋值
  private winNames: string[] = [] // 存储当前窗口名称的集合
  constructor(ctx?: Context) {
    this.ctx = ctx
  }

  // 弹出窗口
  async showAd(url: string, width?: number, height?: number) {
    let name = 'win_' + Math.random();
    const win = await window.createWindow({
      name: name,
      windowType: window.WindowType.TYPE_DIALOG,
      ctx: this.ctx
    })
    if (width && height && width >= 320 && height >= 240) {
      // 子窗口大小有bug 不能小于一定的大小
      // 可以设置maxHeight maxWidth  有bug
      const screen = display.getDefaultDisplaySync()
      screen.height
      const mainWidth = vp2px(width)
      const mainHeight = vp2px(height)
      win.resize(mainWidth, mainHeight)
      win.moveWindowTo((screen.width - mainWidth) / 2, (screen.height - mainHeight) / 2)
    }

    await win.showWindow() // 展示窗口
    // 设置URL地址
    win.setUIContent(url)
    // 将其放入数组
    this.winNames.push(name)
    // 将生成的name返回
    return name
  }

  // 关闭串口
  async closeAd(name?: string) {
    if (name) {
      // 销毁window窗口
      window.findWindow(name).destroyWindow()
      // 删除数组中的name
      this.winNames = this.winNames.filter(item => item !== name)
    } else {
      // 如果没有设置name,将集合中的names全部删除
      let index = 0;
      while (index < this.winNames.length) {
        // 销毁窗口口
        await window.findWindow(this.winNames[index]).destroyWindow();
      }
      // 将集合清空
      this.winNames = []
    }
  }
}

export const winAlert = new WinManager() // 导出一个单例对象


