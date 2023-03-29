

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/pages/other/assets_config.dart';

class GeneralDetailsState extends BaseGetState{

  late TabController tabController;

  late AssetsType assetsType;

  AssetUse? assetUse;

  AssetsInfo? assets;

  GeneralDetailsState(){
    assetsType = Get.arguments["assetsType"];
    assetUse = Get.arguments['assetUse'];
    assets = Get.arguments['assets'];
  }
}