

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class ChoicePeopleState extends BaseGetState{
  var departments = <ITarget>[].obs;

  TextEditingController searchController = TextEditingController();

  var selectedUser = Rxn<XTarget>();

  var selectedGroup = <ITarget>[].obs;


  var searchList = <XTarget>[].obs;

  late List<XTarget> allUser;



  //显示搜索页面
  var showSearchPage = false.obs;
}

