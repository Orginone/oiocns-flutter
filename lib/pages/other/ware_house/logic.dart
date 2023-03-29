import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class WareHouseController extends BaseController<WareHouseState> with GetTickerProviderStateMixin{
 final WareHouseState state = WareHouseState();

 WareHouseController(){
   state.tabController = TabController(length: tabTitle.length, vsync: this);
 }
}
