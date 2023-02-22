
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/util/department_utils.dart';

class CreateTransferState extends BaseGetState{
  late bool isEdit;

  var selectAssetList = <MyAssetsList>[].obs;

  var selectedUser = Rxn<XTarget>();

  var selectedDepartment = Rxn<ITarget>();

  var orderNum = ''.obs;

  late AssetUse draft;

  TextEditingController reasonController = TextEditingController();

  CreateTransferState(){
    List<MyAssetsList> selected = Get.arguments?['selected'] ?? [];
    selectAssetList.addAll(selected);
    isEdit = Get.arguments?['isEdit'] ?? false;
    if(isEdit){
      draft = Get.arguments?['draft'];
      selectAssetList.addAll(draft.approvalDocument?.detail??[]);
      selectedUser.value =  DepartmentUtils().findXTargetById(draft.keeperId??"");
      selectedDepartment.value = DepartmentUtils().findITargetById(draft.keeperOrgId??"");
      orderNum.value = draft.billCode??"";
      reasonController.text = draft.applyRemark??"";
    }
  }
}