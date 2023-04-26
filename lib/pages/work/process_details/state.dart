


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/todo/todo.dart';
import 'package:orginone/pages/work/state.dart';


class ProcessDetailsState extends BaseGetState{

  var hideProcess = true.obs;

  late ITodo todo;

  var flowInstance = Rxn<XFlowInstance>();

  var xAttribute = <String,Map<XOperationItem,dynamic>>{}.obs;


  late TabController tabController;

  ProcessDetailsState(){
    todo = Get.arguments?['todo'];
  }
}

const List<String> tabTitle = [
  '基本信息',
  '历史痕迹',
];