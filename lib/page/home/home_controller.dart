import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_resp/target_resp.dart';
import '../../util/hive_util.dart';
import 'message/message_page.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<TabCombine> tabs = const <TabCombine>[
    TabCombine(Tab(icon: Icon(Icons.directions_bike), child: Text('消息')),
        MessagePage()),
    TabCombine(Tab(icon: Icon(Icons.directions_bike), child: Text('组织架构')),
        MessagePage()),
    TabCombine(Tab(icon: Icon(Icons.directions_bike), child: Text('工作台')),
        MessagePage()),
    TabCombine(Tab(icon: Icon(Icons.directions_bike), child: Text('我的')),
        MessagePage()),
  ];

  TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
  RxList<TargetResp> currentCompanys = <TargetResp>[].obs;

  late TabController tabController =
      TabController(length: tabs.length, vsync: this);
  late TargetResp currentTarget;
  var currentSpaceName = "".obs;

  @override
  void onInit() {
    // 初始化
    List<TargetResp> companys = HiveUtil().getValue(Keys.companys);
    for (var company in companys) {
      currentCompanys.add(company);
    }
    if (companys.isNotEmpty) {
      switchSpaces(companys[0]);
    }
    super.onInit();
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
    tabController.dispose();
    dispose();
    super.onClose();
  }
}

class TabCombine {
  final Tab _tab;
  final Widget _widget;

  const TabCombine(this._tab, this._widget);

  Widget get widget => _widget;

  Tab get tab => _tab;
}
