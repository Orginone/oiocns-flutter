import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
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
   var users =  await identity.value.loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));
   state.unitMember.addAll(users?.result??[]);
  }

  void removeRole(String code) async{
   try{
    var user = state.unitMember.firstWhere((element) => element.code == code);
    bool success = await identity.value.removeMembers([user.id]);
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
        showEditIdentityDialog(identity.value,context,callBack: (name,code,remark) async{
          try{
            ResultType result =await identity.value.updateIdentity(name, code, remark);
            if(result.success){
              identity.value.name = name;
              identity.value.target.code = code;
              identity.value.target.remark = remark;
              identity.refresh();
            }else{
              ToastUtils.showMsg(msg: "修改失败");
            }
          }catch(e){
            ToastUtils.showMsg(msg: e.toString());
          }
        });
        break;
      case IdentityFunction.delete:
        roleSetting.deleteIdentity(identity.value);
        break;
      case IdentityFunction.addMember:
        Get.toNamed(Routers.addMembers,arguments: {"title":"指派角色"});
        break;
    }
  }

}
