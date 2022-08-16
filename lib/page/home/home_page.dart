import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/util/hive_util.dart';

import '../../api_resp/user_resp.dart';
import '../../config/custom_colors.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TabCombine> tabs = controller.tabs;
    final TabController tabController = controller.tabController;

    var height = MediaQuery.of(context).size.height;
    UserResp user = HiveUtil().getValue(Keys.user);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.07),
        child: GFAppBar(
            actions: [
              GFIconButton(
                  color: CustomColors.lightGrey,
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {}),
              GFIconButton(
                  color: CustomColors.lightGrey,
                  icon: const Icon(Icons.repeat, color: Colors.black),
                  onPressed: () {

                  }),
            ],
            backgroundColor: CustomColors.lightGrey,
            leading: Container(
                decoration: const BoxDecoration(
                    color: CustomColors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                child: Text(
                  user.userName
                      .substring(0, user.userName.length >= 2 ? 2 : 1)
                      .toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )),
            title: const Text('Orginone',
                style: TextStyle(color: Colors.black, fontSize: 18))),
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
