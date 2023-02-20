
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/bread_crumb.dart';
import 'package:orginone/components/tab_combine.dart';
import 'package:orginone/pages/todo/todo_list_page.dart';
import 'package:orginone/routers.dart';

typedef TodoCall = void Function(int index);

/// 待办-卡片
Map<String,dynamic> getCards(){
  Map<String, dynamic> mData = {};
  todoFunc(int index) =>
      Get.toNamed(Routers.todoList, arguments: {"index": index});
  mData["常办事项"] = [
    {
      "icon": "",
      "name": "待办",
      "action": "QueryTeamJoinApproval",
      "func": () => todoFunc(0)
    },
    {
      "icon": "",
      "name": "已办",
      "action": "QueryTeamJoinApproval",
      "func": () => todoFunc(1)
    },
    {
      "icon": "",
      "name": "已完成",
      "action": "QueryJoinTeamApply",
      "func": () => todoFunc(2)
    },
    {
      "icon": "",
      "name": "我的发起",
      "action": "QueryJoinTeamApply",
      "func": () => todoFunc(3)
    },
    {"icon": "", "name": "草稿", "action": "draft"},
  ];
  mData["_1"] = [
    {"icon": "", "name": "目录", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "资产申领单", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "监管平台", "action": "QueryJoinTeamApply"},
  ];
  return mData;
}

List<TabCombine> getTabs(TabController tabController) {
  List<TabCombine> tabs = [];
  TabCombine toBe = TabCombine(
    body: Text("我的待办", style: AFont.instance.size20Black3),
    tabView: const TodoListPage(),
    breadCrumbItem: toBePoint,
  );
  TabCombine completed = TabCombine(
    body: Text("我的已办", style: AFont.instance.size20Black3),
    tabView: const TodoListPage(),
    breadCrumbItem: completedPoint,
  );
  TabCombine my = TabCombine(
    body: Text("我的申请", style: AFont.instance.size20Black3),
    tabView: const TodoListPage(),
    breadCrumbItem: myPoint,
  );
  TabCombine sendMy = TabCombine(
    body: Text("抄送我的", style: AFont.instance.size20Black3),
    tabView: const TodoListPage(),
    breadCrumbItem: sendMyPoint,
  );
  tabs = [toBe, completed, my];
  int preIndex = tabController.index;
  tabController.addListener(() {
    if (preIndex == tabController.index) {
      return;
    }
    //TODO: HomeController 确实，暂注释
    // if (Get.isRegistered<HomeController>()) {
    //   var homeController = Get.find<HomeController>();
    //   var bcController = homeController.breadCrumbController;
    //   bcController.redirect(tabs[tabController.index].breadCrumbItem!);
    // }
    preIndex = tabController.index;
  });
  return tabs;
}