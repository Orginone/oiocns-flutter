

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/asset_use.dart';

class AssetsCheckState extends BaseGetState{
  late TabController tabController;
  late AssetUse assetUse;

  AssetsCheckState(){
    assetUse = Get.arguments['assetUse'];
  }
}