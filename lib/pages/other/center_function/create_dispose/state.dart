

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/add_asset/state.dart';

class CreateDisposeState extends BaseGetState{
  late bool isEdit;

  var disposeTyep = "".obs;

  TextEditingController reasonController = TextEditingController();

  var selectAssetList = <SelectAssetList>[].obs;

  CreateDisposeState(){
    isEdit = Get.arguments?['isEdit'] ?? false;
  }
}

