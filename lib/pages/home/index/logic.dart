import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/home/home/logic.dart';
import 'package:orginone/util/page_view_scroll_utils.dart';

import 'state.dart';

class IndexController extends BaseController<IndexState>
    with GetTickerProviderStateMixin {
  final IndexState state = IndexState();

  HomeController homeController = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.tabController = TabController(length: tabTitle.length, vsync: this,animationDuration: Duration.zero);
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
