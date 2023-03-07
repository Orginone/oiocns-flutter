

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';

class ChoiceSpecificAssetsState extends BaseGetState{

  late ISpeciesItem selectedSpecies;

  //选择的二级资产详情
  var selectedSecondLevelAsset = Rxn<ISpeciesItem>();

  //选择的一级资产列表下标
  var selectedChildIndex = 0.obs;

  //选择的二级资产列表下标
  var selectedSecondLevelChildIndex = 0.obs;

  TextEditingController searchController = TextEditingController();

  ChoiceSpecificAssetsState(){
    selectedSpecies = Get.arguments?['selected'];
  }

}