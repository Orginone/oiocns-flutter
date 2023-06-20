import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/work/index.dart';

class ProcessDetailsState extends BaseGetState{

  var hideProcess = true.obs;

  late XWorkTask todo;

  XWorkInstance? workInstance;

  var xAttribute = {}.obs;

  IWork? define;


  Rxn<XForm> workForm = Rxn();

  var thingForm = <XForm>[].obs;


  TabController? subTabController;

  late TabController tabController;

  ProcessDetailsState(){
    todo = Get.arguments?['todo'];
  }
}

const List<String> tabTitle = [
  '基本信息',
  '历史痕迹',
];