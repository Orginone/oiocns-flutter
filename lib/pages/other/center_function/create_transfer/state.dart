
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/add_asset/state.dart';
import 'package:orginone/pages/other/choice_people/state.dart';

class CreateTransferState extends BaseGetState{
  late bool isEdit;

  var selectAssetList = <SelectAssetList>[].obs;

  var selectedUser = Rxn<ZcyUserPos>();

  var selectedDepartment = Rxn<ChoicePeople>();

  TextEditingController reasonController = TextEditingController();

  CreateTransferState(){
    isEdit = Get.arguments?['isEdit'] ?? false;
  }
}