import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class OutAgencyInfoController extends BaseController<OutAgencyInfoState>
    with GetTickerProviderStateMixin {
  final OutAgencyInfoState state = OutAgencyInfoState();

  OutAgencyInfoController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    var users = await state.group.loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));
    state.unitMember.addAll(users.result??[]);
    print(users);
  }

  void changeView(int index) {
   if(state.index.value!=index){
    state.index.value = index;
   }
  }
}
