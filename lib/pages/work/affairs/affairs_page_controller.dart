import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/bread_crumb.dart';
import 'package:orginone/components/tab_combine.dart';
import 'package:orginone/dart/controller/base_controller.dart';
import 'package:orginone/pages/other/home/home_controller.dart';
import 'package:orginone/pages/work/affairs/copy/copy_list.dart';
import 'package:orginone/pages/work/affairs/instance/instance_list.dart';
import 'package:orginone/pages/work/affairs/record/record_list.dart';
import 'package:orginone/pages/work/affairs/task/task_list.dart';

/// 办事模块通用的controller
class AffairsPageController extends BaseController
    with GetSingleTickerProviderStateMixin {
  late List<TabCombine> tabs;
  late TabController tabController;
  late TabCombine toBe, completed, my, sendMy;

  @override
  void onInit() {
    super.onInit();
    _initTabs();
  }

  _initTabs() {
    toBe = TabCombine(
      body: Text("我的待办", style: AFont.instance.size20Black3),
      tabView: const AffairsTaskWidget(),
      breadCrumbItem: toBePoint,
    );
    completed = TabCombine(
      body: Text("我的已办", style: AFont.instance.size20Black3),
      tabView: const AffairsRecordWidget(),
      breadCrumbItem: completedPoint,
    );
    my = TabCombine(
      body: Text("我的申请", style: AFont.instance.size20Black3),
      tabView: const AffairsInstanceWidget(),
      breadCrumbItem: myPoint,
    );
    sendMy = TabCombine(
      body: Text("抄送我的", style: AFont.instance.size20Black3),
      tabView: const AffairsCopyWidget(),
      breadCrumbItem: sendMyPoint,
    );
    tabs = [toBe, completed, my];
    tabController = TabController(length: tabs.length, vsync: this);
    int preIndex = tabController.index;
    tabController.addListener(() {
      if (preIndex == tabController.index) {
        return;
      }
      if (Get.isRegistered<HomeController>()) {
        var homeController = Get.find<HomeController>();
        var bcController = homeController.breadCrumbController;
        bcController.redirect(tabs[tabController.index].breadCrumbItem!);
      }
      preIndex = tabController.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
