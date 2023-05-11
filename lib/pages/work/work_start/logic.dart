import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';



class WorkStartController extends BaseController<WorkStartState> with GetTickerProviderStateMixin{
 final WorkStartState state = WorkStartState();


 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
  }

}
