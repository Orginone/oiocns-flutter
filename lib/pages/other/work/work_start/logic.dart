import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';



class WorkStartController extends BaseController<WorkStartState> with GetTickerProviderStateMixin{
 final WorkStartState state = WorkStartState();

 WorkStartController(){
   state.tabController = TabController(length: tabTitle.length, vsync: this);
 }

}
