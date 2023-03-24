import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ApplicationController extends BaseController<ApplicationState> with GetTickerProviderStateMixin{
 final ApplicationState state = ApplicationState();
 ApplicationController(){
   state.tabController = TabController(length: tabTitle.length, vsync: this);
 }
}
