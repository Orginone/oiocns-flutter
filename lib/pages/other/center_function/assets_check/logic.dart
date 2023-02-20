import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'dialog.dart';
import 'state.dart';

class AssetsCheckController extends BaseController<AssetsCheckState> with GetTickerProviderStateMixin{
 final AssetsCheckState state = AssetsCheckState();

 AssetCheckController(){
   state.tabController = TabController(length: AssetsCheckTabTitle.length, vsync: this);
 }

  void allInventory() {
    CheckDialog.showAllInventoryDialog(context);
  }

}
