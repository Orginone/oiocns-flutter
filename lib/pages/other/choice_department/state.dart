


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/other/choice_people/state.dart';

class ChoiceDepartmentState extends BaseGetState{
  var departments = <IDepartment>[].obs;

  TextEditingController searchController = TextEditingController();

  var selectedDepartment = Rxn<IDepartment>();

  var selectedGroup = <IDepartment>[].obs;


  var searchList = <IDepartment>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;
}