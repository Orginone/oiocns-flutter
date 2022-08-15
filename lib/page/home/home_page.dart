import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TabCombine> tabs = controller.tabs;
    final TabController tabController = controller.tabController;

    return Scaffold(
      appBar: GFAppBar(
        title: const Text('Orginone-IM'),
      ),
      body: GFTabBarView(
          controller: tabController,
          children: tabs.map((e) => e.widget).toList()),
      bottomNavigationBar: GFTabBar(
        length: tabController.length,
        controller: tabController,
        tabs: tabs.map((e) => e.tab).toList(),
      ),
    );
  }
}
