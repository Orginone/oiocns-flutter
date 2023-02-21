

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/my_assets_list.dart';

class CreateDisposeState extends BaseGetState{
  late bool isEdit;

  var disposeTyep = "".obs;

  TextEditingController reasonController = TextEditingController();

  var selectAssetList = <MyAssetsList>[].obs;

  CreateDisposeState() {
    List<MyAssetsList> selected = Get.arguments?['selected'] ?? [];
    selectAssetList.addAll(selected);
    isEdit = Get.arguments?['isEdit'] ?? false;
  }
}

