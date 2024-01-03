import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/system/update_utils.dart';

import 'state.dart';

class HomeController extends BaseController<HomeState>
    with GetTickerProviderStateMixin {
  @override
  final HomeState state = HomeState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('>>>=======Home1');
    state.tabController = TabController(
        length: 5,
        vsync: this,
        initialIndex: 2,
        animationDuration: Duration.zero);
    state.tabController.addListener(() {
      if (relationCtrl.homeEnum.value.index != state.tabController.index) {
        relationCtrl.homeEnum.value =
            HomeEnum.values[state.tabController.index];
      }
    });
    if (Get.arguments ?? false) {
      EventBusUtil.instance.fire(UserLoaded());
    }
    print('>>>=======Home2');
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    AppUpdate.instance.update();
  }

  @override
  void onReceivedEvent(event) {
    if (event is ShowLoading) {
      if (event.isShow) {
        // LoadingDialog.showLoading(Get.context!, msg: "加载数据中");
      } else {
        LoadingDialog.dismiss(Get.context!);
      }
    }
    if (event is StartLoad) {
      EventBusUtil.instance.fire(UserLoaded());
    }
  }

  void jumpTab(HomeEnum relation) {
    // state.tabController.animateTo(relation.index);
    relationCtrl.homeEnum.value = relation;
    state.tabController.index = relation.index;
  }

  @override
  void onClose() {
    state.tabController.dispose();
    super.onClose();
  }
}
