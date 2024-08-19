import { HmNavBar, HmCard, HmCardItem } from '@ohos/basic'
import { MapComponent } from '@hms.core.map.MapComponent'
import { geoLocationManager } from '@kit.LocationKit'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'
import { map, site } from '@kit.MapKit'

@Entry
@Component
struct SelectLocation {
  @State
  list: SiteClass[] = []
  mapController: map.MapComponentController = new map.MapComponentController();

  // 检查权限
  async checkPermission() {
    // 没有去申请
    // 有的话直接获取
    const manager = abilityAccessCtrl.createAtManager() // 得到manager对象
    const appInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION) // 获取应用信息
    const status = manager.checkAccessTokenSync(appInfo.appInfo.accessTokenId, "ohos.permission.LOCATION")
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      // 此时没有权限
      // 没有权限就申请权限
      const result = await manager.requestPermissionsFromUser(getContext(),
        ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"])
      if (result.authResults[0] !== 0) {
        // 这里的代码,都是固定写法
        // 拉起ability
        const context = getContext() as common.UIAbilityContext
        context.startAbility({
          bundleName: 'com.huawei.hmos.settings', // 设置页的包名
          abilityName: 'com.huawei.hmos.settings.MainAbility', // 设置页的ability名层
          uri: "application_info_entry", // 参数名
          parameters: {
            pushParams: appInfo.name // 因为要知道是哪个应用需要打开设置
          }
        })
      } else {
        // 有权限
        this.getLocation();
      }
    } else {
      // 有权限
      this.getLocation();
    }
  }

  // 获取位置
  async getLocation() {
    try {
      const result = await geoLocationManager.getCurrentLocation();
      // 挪动地图到我们的经纬度为止
      //  this.searchPlace()

      // 加上提示文本
      this.mapController.addPointAnnotation({
        position: {
          latitude: result.latitude,
          longitude: result.longitude
        },
        titles: [{
          content: '您当前的位置'
        }]
      })
    } catch (error) {
      AlertDialog.show({ message: error.message })
    }
  }

  // 搜索周边位置
  async searchPlace(result: geoLocationManager.Location) {
    try {
      const res = await site.nearbySearch({
        location: {
          latitude: result.latitude,
          longitude: result.longitude
        },
        pageSize: 4,
        radius: 50// 50米范围内的建筑物
      })
      this.list = res.sites?.slice(0, 4) as SiteClass[]
    } catch (error) {

    }
  }

  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      Stack({ alignContent: Alignment.Bottom }) {
        //  地图区域
        MapComponent({
          mapOptions: {
            position: {
              target: {
                latitude: 39.9,
                longitude: 116.4
              },
              zoom: 10
            }
          },
          mapCallback: () => {
          }
        })
          .width('100%')
          .height('100%')
        Column() {
          HmCard() {
            HmCardItem({ leftTitle: '回龙观街道', rightValue: '100m以内' })
            HmCardItem({ leftTitle: '金燕龙科研楼', rightValue: '100m以内' })
            HmCardItem({ leftTitle: '春野画室', rightValue: '100m以内' })
            HmCardItem({ leftTitle: '光滑时代(金艳龙科研楼店)', rightValue: '100m以内' })
          }
        }
        .padding({
          bottom: 60
        })
      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}

class SiteClass {
  name: string = ""
  distance: number = 0
}