


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/other/choice_people/state.dart';

class ChoiceDepartmentState extends BaseGetState{
  var departments = <ITarget>[].obs;

  TextEditingController searchController = TextEditingController();

  var selectedDepartment = Rxn<ITarget>();

  var selectedGroup = <ITarget>[].obs;

  late List<ITarget> allDepartment;

  var searchList = <ITarget>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;
}