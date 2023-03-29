import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ToDoController extends BaseController<ToDoState> with GetTickerProviderStateMixin{
 final ToDoState state = ToDoState();

 ToDoController(){
   state.tabController = TabController(length: WorkEnum.values.length, vsync: this);
 }
}
