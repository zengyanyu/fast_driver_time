/** 响应数据 */
export interface UserTaskInfo {
  /** 完成任务数量,基于实际完成时间统计 */
  completedAmounts: number;

  /** 每日里程,基于实际完成时间统计 */
  dailyMileage: DailyMileage[];

  /** 任务数量,基于计划完成时间统计 */
  taskAmounts: number;

  /** 运输里程，单位：公里，基于实际完成时间统计 */
  transportMileage: number;
}

export interface DailyMileage {
  /** 日期,格式：2022-07-16 00:00:00 */
  dateTime: string | null;

  /** 里程，单位：公里;计算公式：原始数据（单位米）/1000 四舍五入取整 */
  mileage: number | null;
}

export interface UserTaskInfoParams {
  /** 月 */
  month: string;

  /** 年 */
  year: string;
}

export class UserTaskInfoModel implements UserTaskInfo {
  completedAmounts: number = 0
  dailyMileage: DailyMileage[] = []
  taskAmounts: number = 0
  transportMileage: number = 0

  constructor(model: UserTaskInfo) {
    this.completedAmounts = model.completedAmounts
    this.dailyMileage = model.dailyMileage
    this.taskAmounts = model.taskAmounts
    this.transportMileage = model.transportMileage
  }
}

export class DailyMileageModel implements DailyMileage {
  dateTime: string | null = null
  mileage: number | null = null

  constructor(model: DailyMileage) {
    this.dateTime = model.dateTime
    this.mileage = model.mileage
  }
}

export class UserTaskInfoParamsModel implements UserTaskInfoParams {
  month: string = ''
  year: string = ''

  constructor(model: UserTaskInfoParams) {
    this.month = model.month
    this.year = model.year
  }
}
