import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/routers.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';


class InitiateController extends BaseController<InitiateState> with GetTickerProviderStateMixin{
 final InitiateState state = InitiateState();

 InitiateController(){
   state.tabController = TabController(length: tabTitle.length, vsync: this);
 }

}
