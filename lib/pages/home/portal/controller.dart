import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/utils/hive_utils.dart';

import 'state.dart';

class PortalController extends BaseSubmenuController<PortalState> {
  @override
  final PortalState state = PortalState();

  @override
  void initSubGroup() {
    super.initSubGroup();
    var chat = HiveUtils.getSubGroup('portal');
    if (chat == null) {
      chat = SubGroup.fromJson(portalDefaultConfig);
      HiveUtils.putSubGroup('portal', chat);
    }
    state.subGroup = Rx(chat);
    var index =
        chat.groups!.indexWhere((element) => element.value == "workbench");
    state.tabController = TabController(
        initialIndex: index,
        length: chat.groups!.length,
        vsync: this,
        animationDuration: Duration.zero);
  }
}
