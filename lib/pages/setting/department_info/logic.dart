import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class DepartmentInfoController extends BaseController<DepartmentInfoState>
    with GetTickerProviderStateMixin {
  final DepartmentInfoState state = DepartmentInfoState();

  DepartmentInfoController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  void changeView(int index) {
    if (state.index.value != index) {
      state.index.value = index;
    }
  }

  void removeMember(String data) async {
    var user = state.depart.value.members
        .firstWhere((element) => element.code == data);
    bool success = await state.depart.value.removeMembers([user]);
    if (success) {
      state.depart.value.members.removeWhere((element) => element.code == data);
      state.depart.refresh();
    } else {
      ToastUtils.showMsg(msg: "移除失败");
    }
  }

  void companyOperation(CompanyFunction function) {
    switch (function) {
      case CompanyFunction.roleSettings:
        Get.toNamed(Routers.roleSettings,
            arguments: {"target": state.depart.value});
        break;
      case CompanyFunction.addUser:
        Get.toNamed(Routers.addMembers, arguments: {"title": "指派角色"})
            ?.then((value) async {
          var selected = (value as List<XTarget>);
          if (selected.isNotEmpty) {
            bool success = await state.depart.value.pullMembers(selected);
            if (success) {
              await reloadMembers();
            }
          }
        });
        break;
    }
  }

  Future<void> reloadMembers() async {
    var user = await state.depart.value.loadMembers();
    state.depart.value.members.clear();
    state.depart.value.members.addAll(user);

    state.depart.refresh();
  }
}
