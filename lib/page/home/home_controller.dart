import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/page/home/organization/organization_page.dart';

import '../../api_resp/target_resp.dart';
import '../../util/hive_util.dart';
import 'message/message_page.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);

  late List<TabCombine> tabs;
  late TabController tabController;
  late TargetResp currentTarget;

  RxList<TargetResp> currentCompanys = <TargetResp>[].obs;
  Rx<String> currentSpaceName = "".obs;

  var logger = Logger("HomeController");

  MessageController messageController = Get.find<MessageController>();

  @override
  void onInit() {
    // 初始化 companys
    List<TargetResp> companys = HiveUtil().getValue(Keys.companys);
    for (var company in companys) {
      currentCompanys.add(company);
    }
    if (companys.isNotEmpty) {
      switchSpaces(companys[0]);
    }
    // 初始化 Tabs 以及 TabController
    tabs = <TabCombine>[
      TabCombine(
          _buildTab(Icons.chat_bubble_outline, '消息'), const MessagePage()),
      TabCombine(
          _buildTab(Icons.groups_outlined, '关系'), const OrganizationPage()),
      TabCombine(_buildTab(Icons.work_outline, '工作台'), MessagePage()),
      TabCombine(_buildTab(Icons.person_outline, '我的'), MessagePage()),
    ];
    tabController = TabController(length: tabs.length, vsync: this);
    super.onInit();
  }

  Tab _buildTab(IconData iconData, String label) {
    return Tab(
        iconMargin: const EdgeInsets.all(5),
        icon: Icon(iconData),
        child: Text(label));
  }

  void switchSpaces(TargetResp targetResp) {
    currentTarget = targetResp;
    if (targetResp.name != userInfo.name) {
      currentSpaceName.value = targetResp.name;
    } else {
      currentSpaceName.value = "个人空间";
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    logger.info("===============回收 HomeController 资源==================");
    messageController.dispose();
    tabController.dispose();
    tabs.clear();
    dispose();
    super.onClose();
    logger.info("===============回收 HomeController 资源完成==================");
  }
}

class TabCombine {
  final Tab _tab;
  final Widget _widget;

  const TabCombine(this._tab, this._widget);

  Widget get widget => _widget;

  Tab get tab => _tab;
}
