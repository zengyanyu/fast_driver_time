// 播放轻音
import { media } from '@kit.MediaKit'
import { audio } from '@kit.AudioKit'

export class SoundManager {
  // 播放音频
  async playAudio(audioName: string) {
    if (audioName) {
      try {
        const pool = await media.createSoundPool(5, {
          usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
          rendererFlags: 0
        })
        const des = await getContext().resourceManager.getRawFd(audioName) // 资源管理器 拿到文件的描述
        let streamId = -1
        pool.on("loadComplete", async () => {
          // 此时才是真的加载完成
          // 才可以播放
          streamId = await pool.play(loadId) // 这才是真的播放
        })
        pool.on("playFinished", async () => {
          // 播放完成直接卸载
          await pool.stop(streamId) // 终止播放
          await pool.unload(loadId) // 卸载资源
          pool.release() // 释放内存
        })

        // 拿到了播放的实例
        const loadId = await pool.load(des.fd, des.offset, des.length) // 加载要播放的音频 会返回加载音频的id
        // pool.play(loadId)

        // 释放 播放的streamId
        // 释放加载的id
        // 释放pool
      } catch (error) {
        AlertDialog.show({ message: error.message })
      }

    }

  }
}

export const sound = new SoundManager()