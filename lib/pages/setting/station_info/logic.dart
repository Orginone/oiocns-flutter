import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StationInfoController extends BaseController<StationInfoState> {
 final StationInfoState state = StationInfoState();


 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    state.identitys.value =  await state.station.loadIdentitys(reload: true);
    var users =  await state.station.loadMembers(reload: true);
    state.unitMember.addAll(users);
  }

  void removeMember(String data) async{
    var user = state.unitMember
        .firstWhere((element) => element.code == data);
    bool success = await state.station.removeMembers([user]);
    if (success) {
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    } else {
      ToastUtils.showMsg(msg: "移除失败");
    }
  }

  void companyOperation(CompanyFunction function) {
   switch(function){
     case CompanyFunction.addUser:
       Get.toNamed(Routers.addMembers,arguments: {"title":"添加岗位人员"})?.then((value) async{
         var selected = (value as List<XTarget>);
         if(selected.isNotEmpty){
            bool success = await state.station.pullMembers(selected);
            if (success) {
              state.unitMember.addAll(selected);
              state.unitMember.refresh();
            }
          }
        });
        break;
    }
  }

  void removeAdmin(String data) async {
    try {
      var user = state.identitys.firstWhere((element) => element.metadata.id == data);
      bool success = await state.station.removeIdentitys([user]);
      if (success) {
        state.identitys.remove(user);
      }
    } catch (e) {
      ToastUtils.showMsg(msg: "移除失败");
    }
  }
}
