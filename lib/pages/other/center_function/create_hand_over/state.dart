

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/pages/other/add_asset/state.dart';
import 'package:orginone/pages/other/choice_people/state.dart';
import 'package:orginone/util/department_utils.dart';

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
      selectedUser.value =  DepartmentUtils().findXTargetById(assetUse.userName??"");
      orderNum.value = assetUse.billCode??"";
      reasonController.text = assetUse.applyRemark??"";
    }
  }
}