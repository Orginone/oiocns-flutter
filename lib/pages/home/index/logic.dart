import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/home/home/logic.dart';

import 'state.dart';

class IndexController extends BaseController<IndexState>
    with GetTickerProviderStateMixin {
  @override
  final IndexState state = IndexState();

  HomeController homeController = Get.find();

  @override
  void onInit() {
    super.onInit();
    state.tabController = TabController(
        length: tabTitle.length, vsync: this, animationDuration: Duration.zero);
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
