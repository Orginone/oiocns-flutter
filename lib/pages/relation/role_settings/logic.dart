import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/identity/identity.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/pages/relation/request/network.dart';
import 'package:orginone/utils/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RoleSettingsController extends BaseController<RoleSettingsState>
    with GetTickerProviderStateMixin {
  @override
  final RoleSettingsState state = RoleSettingsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await initRole();
  }

  Future<void> initRole() async {
    state.identitys.clear();
    state.identitys.value = await state.target.loadIdentitys();
    initTabController();
  }

  void initTabController() {
    state.tabController =
        TabController(length: state.identitys.length, vsync: this);
  }

  void createIdentity() async {
    IAuthority? auth = await state.target.space!.loadSuperAuth();

    // ignore: use_build_context_synchronously
    showCreateIdentityDialog(
        context, auth != null ? getAllAuthority([auth]) : [], onCreate:
            (String name, String code, String authID, String remark) async {
      var model =
          IdentityModel(name: name, code: code, authId: authID, remark: remark);
      IIdentity? identity = await state.target.createIdentity(model);
      if (identity != null) {
        ToastUtils.showMsg(msg: "创建成功");
        await initRole();
      } else {
        ToastUtils.showMsg(msg: "创建失败");
      }
    });
  }

  void deleteIdentity(IIdentity identity) async {
    try {
      bool success = await identity.delete();
      if (success) {
        state.identitys.remove(identity);
        initTabController();
      } else {
        ToastUtils.showMsg(msg: "删除失败");
      }
    } catch (e) {
      ToastUtils.showMsg(msg: e.toString());
    }
  }
}
