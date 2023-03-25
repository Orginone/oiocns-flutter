

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/model/assets_info.dart';

import '../../../dart/core/getx/base_get_state.dart';

class AddAssetState extends BaseGetState{
  TextEditingController searchController = TextEditingController();

  var selectCount = 0.obs;

  var selectAll = false.obs;

  var selectAssetList = <AssetsInfo>[].obs;

  var searchList = <AssetsInfo>[].obs;

  AddAssetState(){

  }
}
