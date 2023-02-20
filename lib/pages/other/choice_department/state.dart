


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/choice_people/state.dart';

class ChoiceDepartmentState extends BaseGetState{
  var choicePeople = Rxn<ChoicePeople>();

  TextEditingController searchController = TextEditingController();

  var selectedDepartment = Rxn<ChoicePeople>();

  var selectedGroup = <ChoicePeople>[].obs;


  var searchList = <ChoicePeople>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;
}