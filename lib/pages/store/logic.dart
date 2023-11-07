import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/util/hive_utils.dart';

import 'state.dart';

class StoreController extends BaseSubmenuController<StoreState> {
  @override
  final StoreState state = StoreState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void initSubGroup() {
    // TODO: implement initSubGroup
    super.initSubGroup();
    var store = HiveUtils.getSubGroup('store');
    if (store == null) {
      store = SubGroup.fromJson(storeDefaultConfig);
      HiveUtils.putSubGroup('store', store);
    }
    state.subGroup = Rx(store);
    var index =
        store.groups!.indexWhere((element) => element.value == "common");
    state.tabController = TabController(
        initialIndex: index,
        length: store.groups!.length,
        vsync: this,
        animationDuration: Duration.zero);
  }
}
