import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/page/home/message/message_controller.dart';
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
              PopupMenuButton(
                  icon: const Icon(Icons.repeat, color: Colors.black),
                  offset: Offset(0, height * 0.07 + 5),
                  onSelected: (item) {
                    controller.switchSpaces(item as TargetResp);
                    var messageController = Get.find<MessageController>();
                    messageController.sortingGroup(item);
                  },
                  itemBuilder: (BuildContext context) {
                    return controller.currentCompanys
                        .map((company) => PopupMenuItem(
                            value: company, child: Text(company.name)))
                        .toList();
                  })
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
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(controller.userInfo.name,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              Obx(() => Text("${controller.currentSpaceName}",
                  style: const TextStyle(color: Colors.black, fontSize: 12))),
            ])),
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
