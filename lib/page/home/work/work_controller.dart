import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';

class WorkController extends GetxController {
  late TabController tabController;

  RxInt approvalCount = 0.obs;
  RxInt applyCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    approvalCount.value = await PersonApi.approval();
    applyCount.value = await PersonApi.apply();
  }
}
