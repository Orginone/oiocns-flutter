
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/bread_crumb.dart';
import 'package:orginone/components/tab_combine.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/pages/todo/todo_list_page.dart';
import 'package:orginone/routers.dart';

typedef TodoCall = void Function(int index);

/// 待办-卡片
Map<String,dynamic> getCards(){
  Map<String, dynamic> mData = {};
  todoFunc(int index) =>
      Get.toNamed(Routers.todoList, arguments: {"index": index});
  mData["常用业务"] = [
    {
      "icon": "",
      "name": "待办",
      "action": "QueryTeamJoinApproval",
      "func": () => todoFunc(0)
    },
    {
      "icon": "",
      "name": "我的发起",
      "action": "QueryTeamJoinApproval",
      "func": () => todoFunc(1)
    }
  ];
  mData["全部业务"] = [
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "目录", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "目录", "action": "QueryJoinTeamApply"},
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "具体业务", "action": "QueryTeamJoinApproval"},
    {"icon": "", "name": "目录", "action": "QueryTeamJoinApproval"},
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

List<PopupMenuEntry> getMenu(){
  List<PopupMenuEntry> list = List.empty(growable: true);
  PopupMenuItem popupMenuItem1 = PopupMenuItem(
    value: 1,
    child: Row(
      children: [
        Icon(
          Icons.drafts_outlined,
          color: XColors.black6,
          size: 25.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          "已办业务",
          style: XFonts.size22Black6,
        ),
      ],
    ),
  );
  PopupMenuItem popupMenuItem2 = PopupMenuItem(
    value: 2,
    child: Row(
      children: [
        Icon(
          Icons.assignment_outlined,
          color: XColors.black6,
          size: 25.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          "草稿箱",
          style: XFonts.size22Black6,
        ),
      ],
    ),
  );
  list.add(popupMenuItem1);
  list.add(popupMenuItem2);
  return list;
}