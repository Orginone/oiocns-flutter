import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class XTab {
  final Widget? body;
  final Widget view;
<<<<<<< HEAD
  final Widget? customTab;
  final Widget? icon;
  final double? tabHeight;
  final EdgeInsets? iconMargin;
=======
  final Widget? icon;
  final EdgeInsets? iconMargin;
  final List<Widget> children;
>>>>>>> main

  const XTab({
    Key? key,
    required this.view,
<<<<<<< HEAD
    this.customTab,
    this.body,
    this.icon,
    this.tabHeight,
    this.iconMargin = const EdgeInsets.all(4),
  });

  Widget toTab() {
    if (customTab != null) {
      return customTab!;
    }
    return Tab(
      height: tabHeight ?? 84.h,
      iconMargin: iconMargin!,
      icon: icon,
      child: body,
=======
    this.body,
    this.icon,
    this.iconMargin = const EdgeInsets.all(4),
    this.children = const <Widget>[],
  });

  Widget toTab() {
    return UnconstrainedBox(
      child: Stack(
        children: [
          Tab(
            iconMargin: iconMargin!,
            icon: icon,
            child: body,
          ),
          for (var one in children) one,
        ],
      ),
>>>>>>> main
    );
  }

  Widget toTabView() {
    return view;
  }
}

/// Tab 模板
<<<<<<< HEAD
class Tabs extends StatelessWidget {
=======
class TabsView extends StatelessWidget {
>>>>>>> main
  final Widget? top;
  final List<Widget> views;
  final Widget? bottom;
  final TabController tabCtrl;

<<<<<<< HEAD
  const Tabs({
=======
  const TabsView({
>>>>>>> main
    super.key,
    required this.tabCtrl,
    this.top,
    required this.views,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (top != null) {
      children.add(top!);
    }
    children.add(_main(views));
    if (bottom != null) {
      children.add(bottom!);
    }
    return Column(children: children);
  }

  Widget _main(List<Widget> children) {
    return Expanded(child: TabBarView(controller: tabCtrl, children: children));
  }
}

abstract class TabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final List<XTab> tabs = [];
  final RxnInt initialIndex = RxnInt();

  @override
  void onInit() {
    super.onInit();
    initTabs();
    tabController = TabController(length: tabs.length, vsync: this);
    initListeners();
  }

<<<<<<< HEAD
=======
  @override
  void onClose() {
    tabs.clear();
    tabController.dispose();
    super.onClose();
  }

>>>>>>> main
  /// 初始化 tab
  initTabs();

  /// 初始化监听器
  initListeners() {}

  /// 注册 tab
  registerTab(XTab tab) {
    tabs.add(tab);
  }

  /// 注册监听器
  registerListens(Function(int) callback) {
    tabController.addListener(() {
      callback(tabController.index);
    });
  }

  /// 设置当前 tab 索引
  setIndex(int index) {
    initialIndex.value = index;
  }
}
