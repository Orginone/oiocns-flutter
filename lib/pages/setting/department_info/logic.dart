import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class DepartmentInfoController extends BaseController<DepartmentInfoState>
    with GetTickerProviderStateMixin {
  @override
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
    }
  }

  void companyOperation(CompanyFunction function) {
    switch (function) {
      case CompanyFunction.roleSettings:
        Get.toNamed(Routers.roleSettings,
            arguments: {"target": state.depart.value});
        break;
      case CompanyFunction.addUser:
        showSearchDialog(context, TargetType.person,
            title: "添加成员",
            hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await state.depart.value.pullMembers(list);
            if (success) {
              ToastUtils.showMsg(msg: "添加成功");
            } else {
              ToastUtils.showMsg(msg: "添加失败");
            }
          }
        });
        break;
      default:
    }
  }

  Future<void> reloadMembers() async {
    var user = await state.depart.value.loadMembers();
    state.depart.value.members.clear();
    state.depart.value.members.addAll(user);

    state.depart.refresh();
  }
}
