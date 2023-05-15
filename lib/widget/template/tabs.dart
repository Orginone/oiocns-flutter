import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XTab {
  final Widget view;
  final Widget tab;
  const XTab({
    Key? key,
    required this.view,
    required this.tab,
  });

  Widget toTab() {
    return tab;
  }

  Widget toTabView() {
    return view;
  }
}




/// Tab 模板
class Tabs extends StatelessWidget {
  final Widget? top;
  final List<Widget> views;
  final Widget? bottom;
  final TabController tabCtrl;

  const Tabs({
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
    with GetTickerProviderStateMixin {
  late TabController tabController;
  final List<XTab> tabs = [];

  @override
  void onInit() {
    super.onInit();
    initTabs();
    tabController = TabController(length: tabs.length, vsync: this,initialIndex: initialIndex()??0);
    initListeners();
  }

  @override
  void onClose() {
    super.onClose();
    tabs.clear();
    tabController.dispose();
  }

  /// 初始化 tab
  initTabs();

  /// 初始化监听器
  initListeners() {

  }

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
  int? initialIndex();
}
