import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AffairsController extends GetxController with GetSingleTickerProviderStateMixin{
  // 应用内 Tab
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    // tabController.dispose();
  }
}
