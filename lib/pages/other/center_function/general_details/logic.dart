import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class GeneralDetailsController extends BaseController<GeneralDetailsState> with GetTickerProviderStateMixin{
 final GeneralDetailsState state = GeneralDetailsState();

 GeneralDetailsController(){
  state.tabController = TabController(length: 2,vsync: this);
 }

}
