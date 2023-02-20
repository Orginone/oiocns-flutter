

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/choice_assets/state.dart';

class ChoiceSpecificAssetsState extends BaseGetState{

  late ChildList selectedMock;

  //选择的二级资产详情
  var selectedSecondLevelAsset = Rxn<ChildList>();

  //选择的一级资产列表下标
  var selectedChildIndex = 0.obs;

  //选择的二级资产列表下标
  var selectedSecondLevelChildIndex = 0.obs;

  TextEditingController searchController = TextEditingController();

  ChoiceSpecificAssetsState(){
    selectedMock = Get.arguments?['selected'];
  }

}