import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class DepartmentInfoController extends BaseController<DepartmentInfoState> with GetTickerProviderStateMixin  {
 final DepartmentInfoState state = DepartmentInfoState();

 DepartmentInfoController(){
  state.tabController = TabController(length: tabTitle.length, vsync: this);
 }

 void changeView(int index) {
  if(state.index.value!=index){
   state.index.value = index;
  }
 }
}
