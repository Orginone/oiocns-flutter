

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';

class ChoiceGbState extends BaseGetState{
  var gb = <ISpeciesItem>[].obs;

  TextEditingController searchController = TextEditingController();

  var selectedGb = Rxn<ISpeciesItem>();

  var selectedGroup = <ISpeciesItem>[].obs;

  var searchList = <ISpeciesItem>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;
}

