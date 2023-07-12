import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/main.dart';

import 'state.dart';

class IndexController extends BaseController<IndexState> with GetTickerProviderStateMixin{
 final IndexState state = IndexState();


 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
  }
}
