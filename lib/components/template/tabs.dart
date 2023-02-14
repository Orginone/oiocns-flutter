import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class XTab {
  final Widget? body;
  final Widget tabView;
  final Widget? customTab;
  final Widget? icon;
  final double? tabHeight;
  final EdgeInsets? iconMargin;

  const XTab({
    Key? key,
    required this.tabView,
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
    );
  }

  Widget toTabView() {
    return tabView;
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
    return Expanded(child: TabBarView(children: children));
  }
}

abstract class TabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController _tabController;
  late RxList<XTab> _tabs;

  get tabController => _tabController;

  @override
  void onInit() {
    super.onInit();
    initTabs();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  initTabs();

  registerTab(XTab tab) {
    _tabs.add(tab);
  }

  registerListens(Function(int) callback) {
    _tabController.addListener(() {
      callback(_tabController.index);
    });
  }
}
