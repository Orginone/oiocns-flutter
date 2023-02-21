

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/model/my_assets_list.dart';

import '../../../dart/core/getx/base_get_state.dart';

class AddAssetState extends BaseGetState{
  TextEditingController searchController = TextEditingController();

  var selectCount = 0.obs;

  var selectAll = false.obs;

  var selectAssetList = <MyAssetsList>[].obs;


  AddAssetState(){

  }
}
