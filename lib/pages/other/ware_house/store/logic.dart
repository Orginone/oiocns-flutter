import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StoreController extends BaseController<StoreState> with GetTickerProviderStateMixin{
 final StoreState state = StoreState();

 StoreController(){
   state.tabController = TabController(length: tabTitle.length, vsync: this);
 }
}
