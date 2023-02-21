

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/pages/other/add_asset/state.dart';
import 'package:orginone/pages/other/choice_people/state.dart';

class CreateHandOverState extends BaseGetState{

  late bool isEdit;

  var selectAssetList = <MyAssetsList>[].obs;

  var selectedUser = Rxn<ZcyUserPos>();

  var selectedDepartment = Rxn<ChoicePeople>();

  TextEditingController reasonController = TextEditingController();

  CreateHandOverState(){
    isEdit = Get.arguments?['isEdit'] ?? false;
  }
}