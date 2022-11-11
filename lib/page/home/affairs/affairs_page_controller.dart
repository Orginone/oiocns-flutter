import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/component/tab_combine.dart';
import 'package:orginone/page/home/affairs/copy/copy_list.dart';
import 'package:orginone/page/home/affairs/instance/instance_list.dart';
import 'package:orginone/page/home/affairs/record/record_list.dart';
import 'package:orginone/page/home/affairs/task/task_list.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/public/http/base_controller.dart';

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
      body: Text("待办", style: AFont.instance.size22Black3),
      tabView: const AffairsTaskWidget(),
      breadCrumbItem: toBePoint,
    );
    completed = TabCombine(
      body: Text("待办", style: AFont.instance.size22Black3),
      tabView: const AffairsRecordWidget(),
      breadCrumbItem: completedPoint,
    );
    my = TabCombine(
      body: Text("我发起的", style: AFont.instance.size22Black3),
      tabView: const AffairsInstanceWidget(),
      breadCrumbItem: myPoint,
    );
    sendMy = TabCombine(
      body: Text("抄送我的", style: AFont.instance.size22Black3),
      tabView: const AffairsCopyWidget(),
      breadCrumbItem: sendMyPoint,
    );
    tabs = [toBe, completed, my, sendMy];
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
