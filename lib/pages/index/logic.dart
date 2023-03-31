import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';

import 'state.dart';

class IndexController extends BaseController<IndexState> with GetTickerProviderStateMixin{
 final IndexState state = IndexState();

 IndexController(){
   state.indextabController = TabController(length: indexTabTitle.length, vsync: this);
 }
}
