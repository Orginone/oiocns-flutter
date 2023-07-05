import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/dart/core/work/task.dart';

class ProcessDetailsState extends BaseGetState{

  var hideProcess = true.obs;

  late IWorkTask todo;

  WorkNodeModel? node;

  var xAttribute = {}.obs;

  Rxn<XForm> mainForm = Rxn();

  var subForm = <XForm>[].obs;


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