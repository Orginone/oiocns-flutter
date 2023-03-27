import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/market/index.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';
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
    // TODO: implement loadData
    await initData();
  }

  Future<void> initData() async{
   var data  = await settingCtrl.user!.getOwnProducts();
   List<IProduct> products = [];
   String status = tabTitle[state.index];
   if (status == "全部") {
    products = data;
   } else {
    var list;
    if(status == "共享的"){
     list = data.where((p0) => p0.prod.belongId != settingCtrl.space.id);
    }else{
     list = data.where((p0) => p0.prod.source == status && p0.prod.belongId == settingCtrl.space.id);
    }
    if (list.isNotEmpty) {
     products = list.toList();
    }
   }
   state.dataList.value = products;
   loadSuccess();
  }

  void changeIndex(int index) {
   if(state.index != index){
    state.index = index;
    loadData();
   }
  }

  void jumpFile(IFileSystemItem file) {
    Get.toNamed(Routers.file,arguments: {'file':file});
  }
}
