import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';

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
}
