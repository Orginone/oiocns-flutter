import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
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
    // var users = await state.settingController.space
    //     .loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));
    var company =
        await state.settingController.user?.getJoinedCompanys(reload: true);
    state.unitMember.clear();
    state.joinCompany.clear();
    // state.unitMember.addAll(users.result ?? []);
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
            title: "添加成员",
            hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await state.settingController.user!.pullMembers(
                list.map((e) => e.id).toList(), TargetType.person.label);
            if (success) {
              ToastUtils.showMsg(msg: "添加成功");
              state.unitMember.addAll(list);
              state.unitMember.refresh();
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
            try {
              for (var element in list) {
                await state.settingController.user!.applyJoinCompany(element.id,TargetType.company);
              }
              ToastUtils.showMsg(msg: "发送成功");
            } catch (e) {
              ToastUtils.showMsg(msg: "发送失败");
            }
          }
        });
        break;
    }
  }

  void removeMember(String data) async{
    var user = state.unitMember.firstWhere((element) => element.code == data);
    bool success = await  state.settingController.user!.removeMember(user);
    if(success){
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    }else{
      ToastUtils.showMsg(msg: "移除失败");
    }

  }

  void removeCompany(String data) async{
    var company = state.joinCompany.firstWhere((element) => element.name == data);
    bool success = await  state.settingController.user!.deleteCompany(company.id);
    if(success){
      state.joinCompany.removeWhere((element) => element.name == data);
      state.joinCompany.refresh();
    }else{
      ToastUtils.showMsg(msg: "移除失败");
    }
  }
}
