import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/network.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RoleSettingsController extends BaseController<RoleSettingsState>
    with GetTickerProviderStateMixin {
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
    state.identitys.value = await state.target.getIdentitys() ?? [];
    initTabController();
  }

  void initTabController(){
    state.tabController =
        TabController(length: state.identitys.length, vsync: this);
  }

  void createIdentity() async{

    List<IAuthority> auth = await SettingNetWork.getAuthority(state.target);
    showCreateIdentityDialog(context,auth,onCreate: (String name, String code, String authID,String remark) async{
     var model = IdentityModel(name: name,code: code,authId: authID,remark: remark);
     IIdentity? identity = await state.target.createIdentity(model);
     if(identity!=null){
       ToastUtils.showMsg(msg: "创建成功");
       await initRole();
     }else{
       ToastUtils.showMsg(msg: "创建失败");
     }
    });

  }

  void deleteIdentity(IIdentity identity) async {
    try {
      bool success = await state.target?.deleteIdentity(identity.id) ??
          false;
      if (success) {
        state.identitys.removeWhere((element) => element.id == identity.id);
        initTabController();
      } else {
        ToastUtils.showMsg(msg: "删除失败");
      }
    } catch (e) {
      ToastUtils.showMsg(msg: e.toString());
    }
  }
}
