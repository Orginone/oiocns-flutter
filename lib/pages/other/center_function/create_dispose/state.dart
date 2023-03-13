

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/pages/other/assets_config.dart';

class CreateDisposeState extends BaseGetState{
  late bool isEdit;

  var disposeType = "".obs;

  var unitType = "".obs;

  var assessment = "".obs;

  TextEditingController reasonController = TextEditingController();

  TextEditingController unitController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  var orderNum = '';

  var selectAssetList = <AssetsInfo>[].obs;

  late AssetUse assetUse;

  CreateDisposeState() {
    List<AssetsInfo> selected = Get.arguments?['selected'] ?? [];
    selectAssetList.addAll(selected);
    isEdit = Get.arguments?['isEdit'] ?? false;
    if(isEdit){
      assetUse = Get.arguments?['assetUse'];
      selectAssetList.addAll(assetUse.approvalDocument?.detail??[]);
      if(assetUse.way!=null){
        disposeType.value = DisposeTyep[assetUse.way!];
      }
      if(assetUse.keepOrgType!=null){
        unitType.value = AssetAcceptanceUnitType[assetUse.keepOrgType!];
      }
      if(assetUse.evaluated!=null){
        assessment.value = Whether[assetUse.evaluated!];
      }
      unitController.text = assetUse.keepOrgName??"";
      phoneNumberController.text = assetUse.keepOrgPhoneNumber == null?"":assetUse.keepOrgPhoneNumber.toString();

      orderNum = assetUse.billCode??"";
      reasonController.text = assetUse.applyRemark??"";
    }
  }
}

