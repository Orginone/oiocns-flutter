import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
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
    var users = await state.settingController.space
        .loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));
    var group = await state.settingController.company?.getJoinedGroups(reload: true);
    state.unitMember.addAll(users.result ?? []);
    state.joinGroup.addAll(group??[]);
  }

  void changeView(int index) {
    if(state.index.value!=index){
      state.index.value = index;
    }
  }

  void companyOperation(CompanyFunction function) {
    switch(function){

      case CompanyFunction.roleSettings:
         Get.toNamed(Routers.roleSettings,arguments: {"company":state.company});
        break;
      case CompanyFunction.addUser:
        break;
      case CompanyFunction.addGroup:
        // TODO: Handle this case.
        break;
    }
  }

  void removeMember(String data) async{
    var user = state.unitMember.firstWhere((element) => element.code == data);
    bool success = await  state.settingController.space.removeMember(user);
    if(success){
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    }else{
      ToastUtils.showMsg(msg: "移除失败");
    }

  }
}
