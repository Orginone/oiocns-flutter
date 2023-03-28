import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/market/index.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class WareHouseManagementController
    extends BaseListController<WareHouseManagementState>
    with GetTickerProviderStateMixin {
  final WareHouseManagementState state = WareHouseManagementState();
  SettingController get settingCtrl => Get.find<SettingController>();
  WareHouseManagementController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.recentlyList.add(
        Recent("0000", "资产管家", "http://anyinone.com:888/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "一警一档", "http://anyinone.com:888/img/logo/logo3.jpg"));
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    loadSuccess();
  }

  void changeIndex(int index) {
   if(state.index != index){
    state.index = index;
   }
  }

  void selectSpecies(ISpeciesItem item) {
    state.selectedSpecies.add(item);
  }

  void clearSpecies() {
    state.selectedSpecies.clear();
  }

  void removeSpecies(index) {
    state.selectedSpecies.removeRange(index + 1, state.selectedSpecies.length);
    state.selectedSpecies.refresh();
  }

}
