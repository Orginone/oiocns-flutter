import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/target/todo/work.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/pages/other/work/initiate_work/state.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';



class WorkStartController extends BaseController<WorkStartState> with GetTickerProviderStateMixin{
 final WorkStartState state = WorkStartState();


 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    if(state.work.workType == WorkType.organization){
      state.define.value = await (state.work.space as ITarget).loadWork();
    } else if(state.work.workType == WorkType.group){
      state.define.value = await (state.work.source as ISpeciesItem).loadWork();
    }
  }

}
