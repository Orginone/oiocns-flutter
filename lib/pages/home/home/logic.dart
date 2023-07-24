import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/user_controller.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class HomeController extends BaseController<HomeState>with GetTickerProviderStateMixin {
  final HomeState state = HomeState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.tabController = TabController(length: 5, vsync: this,initialIndex: 2,animationDuration: Duration.zero);
    state.tabController.addListener(() {
      if(settingCtrl.homeEnum.value.index != state.tabController.index){
         settingCtrl.homeEnum.value = HomeEnum.values[state.tabController.index];
       }
    });
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
    state.tabController.animateTo(setting.index);
    settingCtrl.homeEnum.value = setting;
  }

  @override
  void onClose() {
    state.tabController.dispose();
    super.onClose();
  }
}
