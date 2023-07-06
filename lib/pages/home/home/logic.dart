import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class HomeController extends BaseController<HomeState> {
  final HomeState state = HomeState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments ?? false) {
      XEventBus.instance.fire(UserLoaded());
    }
  }

  @override
  void onReceivedEvent(event) {
    if (event is ShowLoading) {
      if (event.isShow) {
        LoadingDialog.showLoading(Get.context!, msg: "加载数据中");
      } else {
        LoadingDialog.dismiss(Get.context!);
      }
    }
    if (event is StartLoad) {
      XEventBus.instance.fire(UserLoaded());
    }
  }

  void jumpTab(HomeEnum setting) {
    state.pageController.jumpToPage(setting.index);
    settingCtrl.homeEnum.value = setting;
  }
}
