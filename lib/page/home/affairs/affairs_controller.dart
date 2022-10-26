import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/api/workflow_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

class AffairsController extends GetxController with GetSingleTickerProviderStateMixin{
  // 应用内 Tab
  late TabController tabController;
  int limit = 1000;
  int offset = 0;
  List<TargetResp> taskList = [];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    getWaiting();
  }

  Future<void> getWaiting() async {
    var pageResp = await WorkflowApi.task(limit, offset, 'string');
    taskList.addAll(pageResp.result);
    update();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
