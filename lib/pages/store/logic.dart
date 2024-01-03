import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';

import 'config.dart';
import 'state.dart';

class StoreController extends BaseSubmenuController<StoreState> {
  @override
  final StoreState state = StoreState();

  ///初始化 子分组
  @override
  void initSubGroup() {
    super.initSubGroup();
    // var store = HiveUtils.getSubGroup('store');
    // if (store == null) {
    //   store = SubGroup.fromJson(storeDefaultConfig);
    //   HiveUtils.putSubGroup('store', store);
    // }
    ///加载数据动态标签
    var store = loadDataTabs();
    state.subGroup = Rx(store);
    // var index = store.groups!.indexWhere((element) => element.value == "all");
    var index = 0;
    state.tabController = TabController(
        initialIndex: index,
        length: store.groups!.length,
        vsync: this,
        animationDuration: Duration.zero);
  }
}
