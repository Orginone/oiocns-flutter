

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/util/hive_utils.dart';

class CreateDisposeState extends BaseGetState{
  late bool isEdit;


  var selectAssetList = <AssetsInfo>[].obs;

  late AssetUse assetUse;

  late AssetCreationConfig config;

  CreateDisposeState() {
    config = HiveUtils.getConfig("dispose");
    List<AssetsInfo> selected = Get.arguments?['selected'] ?? [];
    selectAssetList.addAll(selected);
    isEdit = Get.arguments?['isEdit'] ?? false;
    if(isEdit){
      assetUse = Get.arguments?['assetUse'];
      for (var element in config.config![0].fields!) {
        element.initDefaultData(assetUse.toJson());
      }
      selectAssetList.addAll(assetUse.approvalDocument?.detail??[]);
    }
  }
}

