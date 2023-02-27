

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/util/department_management.dart';

class CreateHandOverState extends BaseGetState{

  late bool isEdit;

  var selectAssetList = <MyAssetsList>[].obs;

  var selectedUser = Rxn<XTarget>();

  var selectedDepartment = Rxn<ITarget>();

  var orderNum = ''.obs;

  late AssetUse assetUse;

  TextEditingController reasonController = TextEditingController();


  CreateHandOverState(){
    isEdit = Get.arguments?['isEdit'] ?? false;
    if(isEdit){
      assetUse = Get.arguments?['assetUse'];
      selectAssetList.addAll(assetUse.approvalDocument?.detail??[]);
      selectedUser.value =  DepartmentManagement().findXTargetByIdOrName(name: assetUse.userName??"");
      orderNum.value = assetUse.billCode??"";
      reasonController.text = assetUse.applyRemark??"";
    }
  }
}