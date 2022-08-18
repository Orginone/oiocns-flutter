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

  late TabController tabController =
      TabController(length: tabs.length, vsync: this);
  RxList<TargetResp> currentCompanys = <TargetResp>[].obs;

  @override
  void onInit() {
    // 初始化
    List<TargetResp> companys = HiveUtil().getValue(Keys.companys);
    for (var company in companys) {
      currentCompanys.add(company);
    }
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
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
