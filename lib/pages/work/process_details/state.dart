import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/work/todo.dart';


class ProcessDetailsState extends BaseGetState{

  var hideProcess = true.obs;

  late ITodo todo;

  var workInstance = Rxn<XWorkInstance>();

  var xAttribute = {}.obs;


  late TabController tabController;

  ProcessDetailsState(){
    todo = Get.arguments?['todo'];
  }
}

const List<String> tabTitle = [
  '基本信息',
  '历史痕迹',
];