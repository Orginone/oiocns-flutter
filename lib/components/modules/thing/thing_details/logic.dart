import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ThingDetailsController extends BaseController<ThingDetailsState>
    with GetTickerProviderStateMixin {
  @override
  final ThingDetailsState state = ThingDetailsState();

  ThingDetailsController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onInit() {
    // TODO: onRecordRecent 方法不存在 使用时看逻辑
    super.onInit();
    // settingCtrl.store.onRecordRecent(
    //     RecentlyUseModel(type: StoreEnum.thing.label, thing: state.thing));
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }
}
