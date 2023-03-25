import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';

import 'state.dart';

class WorkController extends BaseController<WorkState> with GetTickerProviderStateMixin{
 final WorkState state = WorkState();

 WorkController(){
   state.tabController = TabController(length: tabTitle.length, vsync: this);
 }
}
