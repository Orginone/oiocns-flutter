import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class UserInfoController extends BaseController<UserInfoState>
    with GetTickerProviderStateMixin {
  final UserInfoState state = UserInfoState();

  UserInfoController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await init();
  }

  Future<void> init() async {
    var users = await settingCtrl.user.loadMembers();
    var company = await settingCtrl.user.loadCompanys(reload: true);
    state.unitMember.clear();
    state.joinCompany.clear();
    state.unitMember.addAll(users ?? []);
    state.joinCompany.addAll(company ?? []);
  }

  void changeView(int index) {
    if (state.index.value != index) {
      state.index.value = index;
    }
  }

  void userOperation(UserFunction function) {
    switch (function) {
      case UserFunction.record:
        break;
      case UserFunction.addUser:
        showSearchDialog(context, TargetType.person,
            title: "添加好友",
            hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await settingCtrl.user.pullMembers(list);
            if (success) {
              ToastUtils.showMsg(msg: "添加成功");
            } else {
              ToastUtils.showMsg(msg: "添加失败");
            }
          }
        });
        break;
      case UserFunction.addGroup:
        showSearchDialog(context, TargetType.company,
            title: "加入单位",
            hint: "请输入单位的社会统一信用代码", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            await settingCtrl.user.applyJoin(list);
          }
        });
        break;
    }
  }

  void removeMember(String data) async{
    var user = state.unitMember.firstWhere((element) => element.code == data);
    bool success = await settingCtrl.user.removeMembers([user]);
    if (success) {
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    }
  }

  void removeCompany(String data) async {
    var company = state.joinCompany
        .firstWhere((element) => element.metadata.name == data);
    bool success = await company.exit();
    if (success) {
      state.joinCompany.remove(company);
      state.joinCompany.refresh();
    } else {
      ToastUtils.showMsg(msg: "移除失败");
    }
  }
}
