import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/event_bus_helper.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'assets_page/network.dart';
import 'state.dart';

class CenterFunctionController extends BaseController<CenterFunctionState> with GetTickerProviderStateMixin{
 final CenterFunctionState state = CenterFunctionState();


 @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    state.tabController = TabController(length: state.tabTitle.length, vsync: this);
  }

 void qrScan() {
   Get.toNamed(Routers.qrScan)?.then((value) {
     if (value != null) {
       AssetNetWork.getQrScanData().then((value){
         if(value!=null){
           Get.toNamed(Routers.assetsDetails,arguments: {"assets":value});
         }
       });
     }
   });
 }
}
