
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';

class CreateTransferState extends BaseGetState{
  late bool isEdit;

  var selectAssetList = <AssetsInfo>[].obs;

  ITarget? selectedDepartment;

  late AssetUse assetUse;

  late AssetCreationConfig config;

  CreateTransferState(){
    config = HiveUtils.getConfig("transfer");
    List<AssetsInfo> selected = Get.arguments?['selected'] ?? [];
    selectAssetList.addAll(selected);
    isEdit = Get.arguments?['isEdit'] ?? false;
    if(isEdit){
      assetUse = Get.arguments?['assetUse'];
      selectAssetList.addAll(assetUse.approvalDocument?.detail??[]);
      selectedDepartment = DepartmentManagement().findITargetByIdOrName(id: assetUse.keeperOrgId??"");
      for (var element in config.config![0].fields!) {
         element.initDefaultData(assetUse.toJson());
      }
    }
  }
}