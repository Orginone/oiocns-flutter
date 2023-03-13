import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'check/logic.dart';
import 'check/network.dart';
import 'dialog.dart';
import 'state.dart';

class AssetsCheckController extends BaseController<AssetsCheckState> with GetTickerProviderStateMixin{
  final AssetsCheckState state = AssetsCheckState();

  CheckController get checkController =>
      Get.find<CheckController>(tag: "CheckPage未盘点");

  AssetsCheckController() {
    state.tabController =
        TabController(length: AssetsCheckTabTitle.length, vsync: this);
  }

  void allInventory() {
    CheckDialog.showAllInventoryDialog(context,
        count: checkController.state.dataList.length, onSubmit: () {
          checkController.allInventory();
        });
  }

  void qrScan() {
    Get.toNamed(Routers.qrScan)?.then((value){
      CheckNetwork.getQrScanData(value).then((value){
        if(value!=null){
          Get.toNamed(Routers.generalDetails,arguments: {"assetsType":AssetsType.check,"assets":value});
        }
      });
    });
  }
}
