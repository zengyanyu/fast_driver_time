import { TOKEN_KEY } from '@ohos/basic/src/main/ets/constants/setting'
import { UserSettingClass } from '@ohos/basic/src/main/ets/utils/setting'
import { login } from '../../api'
import { LoginForm, LoginFormModel } from '../../viewmodels'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct Login {
  @State
  accountForm: LoginFormModel = new LoginFormModel({
    account: 'zengyy',
    password: 'zengyy'
  })
  @State
  showLoading: boolean = false // 展示加载进度

  // @State
  // accountForm: LoginForm = { account: "", password: '' }
  // @State
  // accountForm: LoginForm = {} as LoginForm
  // @State
  // accountForm: Partial<LoginForm> = {}


  @Styles
  loginStyle() {
    .backgroundColor('#fff')
    .border({ color: $r('app.color.background_divider'), width: { bottom: 1 } })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }

  // 表单校验
  getFormValidate() {
    if (this.accountForm.account && this.accountForm.password) {
      return true
    }
    return false
  }

  // 登录方法
  async login() {
    try {
      this.showLoading = true
      // 登录获取的token
      const token = await login(this.accountForm)
      // 设置首选项
      new UserSettingClass(getContext()).setToken(token)
      // 设置全局状态
      AppStorage.setOrCreate(TOKEN_KEY, token)
      // this.showLoading = false
      promptAction.showToast({ message: '登录成功' })
      router.replaceUrl({
        url: 'pages/Index/Index'
      })
    } catch (error) {

    } finally {
      // 不论成功或者失败 都关闭进度
      this.showLoading = false
    }
  }

  build() {
    Column() {
      // 顶部标题
      Text("小时达").fontColor($r('app.color.text_primary')).fontSize(18).height(25)
      // 账号登录
      Row() {
        Text('账号登录').fontColor($r('app.color.text_primary')).fontSize(24).fontWeight(FontWeight.Bold)
        Row() {
          Text("账号登录").fontColor($r('app.color.primary')).fontSize(16).fontWeight(FontWeight.Bold)
          Image($r("app.media.ic_angle")).width(10).height(10).margin({ left: 5 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      // 用户名输入框
      TextInput({ placeholder: '请输入账号', text: this.accountForm.account })
        .loginStyle()
        .onChange(value => {
          this.accountForm.account = value
        })

      // 密码框
      TextInput({ placeholder: '请输入密码', text: this.accountForm.password })
        .loginStyle()
        .type(InputType.Password)// 密码框
        .showPasswordIcon(true)// 显示密码按钮
        .onChange(value => {
          this.accountForm.password = value
        })

      // 登录按钮
      Button({ type: ButtonType.Capsule }) {
        Row() {
          if (this.showLoading) {
            LoadingProgress().width(20).height(20).margin({ right: 12 }).color($r('app.color.white'))
          }
          Text('登录').fontColor($r('app.color.white'))
        }
      }
      .backgroundColor($r('app.color.primary'))
      .enabled(this.getFormValidate())
      .width('100%')
      .height(50)
      .margin({ top: 50 })
      .onClick(() => {
        this.login()
      })
    }
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }
}