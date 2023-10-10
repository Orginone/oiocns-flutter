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

class OutAgencyInfoController extends BaseController<OutAgencyInfoState>
    with GetTickerProviderStateMixin {
  @override
  final OutAgencyInfoState state = OutAgencyInfoState();

  OutAgencyInfoController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onReady() async {
    super.onReady();
    var users = await state.group.loadMembers();
    state.unitMember.addAll(users);
  }

  void changeView(int index) {
    if (state.index.value != index) {
      state.index.value = index;
    }
  }

  void companyOperation(CompanyFunction function) {
    switch (function) {
      case CompanyFunction.roleSettings:
        Get.toNamed(Routers.roleSettings, arguments: {"target": state.group});
        break;
      case CompanyFunction.addUser:
        showSearchDialog(context, TargetType.company,
            title: "添加成员",
            hint: "请输入单位的社会统一信用代码", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await state.group.pullMembers(list);
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
      case CompanyFunction.addGroup:
        showSearchDialog(context, TargetType.group,
            title: "加入集团",
            hint: "请输入集团的编码", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            try {
              // await state.group.company.applyJoin(list);
              ToastUtils.showMsg(msg: "发送成功");
            } catch (e) {
              ToastUtils.showMsg(msg: "发送失败");
            }
          }
        });
        break;
    }
  }

  void removeMember(String data) async {
    var user = state.unitMember.firstWhere((element) => element.name == data);
    bool success = await state.group.removeMembers([user]);
    if (success) {
      state.unitMember.removeWhere((element) => element.name == data);
      state.unitMember.refresh();
    }
  }
}
