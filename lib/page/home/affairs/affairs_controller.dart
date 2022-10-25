import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AffairsController extends GetxController with GetSingleTickerProviderStateMixin{
  // 应用内 Tab
  late TabController tabController;
  int limit = 1000;
  int offset = 0;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }


  void getWaiting(){
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
