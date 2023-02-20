

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/assets_config.dart';

class GeneralDetailsState extends BaseGetState{

  late TabController tabController;

  late AssetsType assetsType;

  AssetsDetailsState(){
    assetsType = Get.arguments["AssetsType"];
  }
}