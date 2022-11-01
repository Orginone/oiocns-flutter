import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/public/http/base_controller.dart';

/// 办事模块通用的controller
class AffairsPageController extends BaseController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt index = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      index.value = tabController.index;
      int previousIndex = tabController.previousIndex;
      print('previousIndex $previousIndex');
      print('previousIndex ${index.value}');
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
