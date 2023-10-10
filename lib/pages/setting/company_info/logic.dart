import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CompanyInfoController extends BaseController<CompanyInfoState>
    with GetTickerProviderStateMixin {
  final CompanyInfoState state = CompanyInfoState();

  CompanyInfoController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await init();
  }

  Future<void> init() async {
    var users = await state.company.loadMembers();
    var group = await state.company.loadGroups(reload: true);
    state.unitMember.clear();
    state.joinGroup.clear();
    state.unitMember.addAll(users);
    state.joinGroup.addAll(group ?? []);
  }

  void changeView(int index) {
    if (state.index.value != index) {
      state.index.value = index;
    }
  }

  void companyOperation(CompanyFunction function) {
    switch (function) {
      case CompanyFunction.roleSettings:
        Get.toNamed(Routers.roleSettings, arguments: {"target": state.company});
        break;
      // case CompanyFunction.addUser:
      //   showSearchDialog(context, TargetType.person,
      //       title: "邀请成员",
      //       hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
      //     if (list.isNotEmpty) {
      //       bool success = await state.company.pullMembers(list);
      //       if (success) {
      //         ToastUtils.showMsg(msg: "添加成功");
      //         state.unitMember.addAll(list);
      //         state.unitMember.refresh();
      //       } else {
      //         ToastUtils.showMsg(msg: "添加失败");
      //       }
      //     }
      //   });
      //   break;
      // case CompanyFunction.addGroup:
      //   showSearchDialog(context, TargetType.group,
      //       title: "加入集团",
      //       hint: "请输入集团的编码", onSelected: (List<XTarget> list) async {
      //     if (list.isNotEmpty) {
      //       try {
      //         await state.company.applyJoin(list);
      //         ToastUtils.showMsg(msg: "发送成功");
      //       } catch (e) {
      //         ToastUtils.showMsg(msg: "发送失败");
      //       }
      //     }
      //   });
      //   break;
    }
  }

  void removeMember(String data) async {
    var user = state.unitMember.firstWhere((element) => element.code == data);
    bool success = await state.company.removeMembers([user]);
    if (success) {
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    }
  }
}
