import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StoreController extends BaseController<StoreState>
    with GetTickerProviderStateMixin {
  @override
  // ignore: overridden_fields
  final StoreState state = StoreState();

  StoreController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);

    state.recentlyList.add(
        Popular("0000", "资产管家", "http://anyinone.com:888/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Popular("0001", "一警一档", "http://anyinone.com:888/img/logo/logo3.jpg"));
  }
}
