import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/utils/hive_utils.dart';
import 'state.dart';

class WorkController extends BaseSubmenuController<WorkState> {
  @override
  // ignore: overridden_fields
  final WorkState state = WorkState();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void initSubGroup() {
    super.initSubGroup();
    var work = HiveUtils.getSubGroup('work');
    if (work == null) {
      work = SubGroup.fromJson(workDefaultConfig);
      HiveUtils.putSubGroup('work', work);
    }
    state.subGroup = Rx(work);
    // var index = work.groups!.indexWhere((element) => element.value == "todo");
    state.tabController = TabController(
        initialIndex: state.tabIndex,
        length: work.groups?.length ?? 0,
        vsync: this,
        animationDuration: Duration.zero);
  }

  @override
  int getTabIndex(String code) {
    return SubGroup.fromJson(workDefaultConfig)
        .groups!
        .indexWhere((element) => element.value == code);
  }
}
