


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';

class WorkStartState extends BaseGetState{

  late WorkBreadcrumbNav work;

  var define = <XWorkDefine>[].obs;

  WorkStartState(){
    work = Get.arguments['data'];
  }

}