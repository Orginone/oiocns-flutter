import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/identity/identity.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/role_settings/logic.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class IdentityInfoController extends BaseController<IdentityInfoState> {
  final IdentityInfoState state = IdentityInfoState();
  late Rx<IIdentity> identity;

  RoleSettingsController get roleSetting =>Get.find<RoleSettingsController>();

  IdentityInfoController(this.identity);


  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await loadMembers();
  }

  Future<void> loadMembers() async{
    var users =  await identity.value.loadMembers();
    state.unitMember.clear();
    state.unitMember.addAll(users);
  }

  void removeRole(String code) async{
   try{
    var user = state.unitMember.firstWhere((element) => element.code == code);
    bool success = await identity.value.removeMembers([user]);
    if(success){
     state.unitMember.removeWhere((element) => element.code == code);
     state.unitMember.refresh();
    }else{
     ToastUtils.showMsg(msg: "移除失败");
    }
   }catch(e){
    ToastUtils.showMsg(msg: e.toString()+code);
   }
  }

  void identityOperation(IdentityFunction function) {
    switch(function){
      case IdentityFunction.edit:
        showCreateIdentityDialog(context,[],onCreate: (name,code,authId,remark) async{
          try{
            bool success =await identity.value.update(IdentityModel(name:name, code:code, remark:remark));
            if(success){
              identity.value.metadata.name = name;
              identity.value.metadata.code = code;
              identity.value.metadata.remark = remark;
              identity.refresh();
            }else{
              ToastUtils.showMsg(msg: "修改失败");
            }
          }catch(e){
            ToastUtils.showMsg(msg: e.toString());
          }
        },identity: identity.value);
        break;
      case IdentityFunction.delete:
        roleSetting.deleteIdentity(identity.value);
        break;
      case IdentityFunction.addMember:
        Get.toNamed(Routers.addMembers,arguments: {"title":"指派角色"})?.then((value) async{
          var selected = (value as List<XTarget>);
          if(selected.isNotEmpty){
            bool success = await identity.value.pullMembers(selected);
            if(success){
              await loadMembers();
            }
          }
        });
        break;
    }
  }

}
