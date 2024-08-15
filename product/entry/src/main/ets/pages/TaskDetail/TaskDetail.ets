import { router } from '@kit.ArkUI';
import { getTaskDetailAPI } from '../../api';
import { CommonRouterParams } from '../../viewmodels';

/**
 * 任务详情
 */
@Entry
@Component
struct TaskDetail {
  @State message: string = '任务详情';

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    // AlertDialog.show({ message: params.id })
    if (params) {
      this.getTaskDetail(params.id as string)
    }
  }

  async getTaskDetail(id: string) {
    const result = await getTaskDetailAPI(id);
    AlertDialog.show({ message: JSON.stringify(result) })
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }
    .height('100%')
    .width('100%')
  }
}