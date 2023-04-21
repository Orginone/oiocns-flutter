

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/home/setting/state.dart';

class RelationGroupState extends BaseBreadcrumbNavState<SettingFunctionBreadcrumbNavModel>{


  bool get isStandard => model.value?.standardEnum!=null;

  RelationGroupState(){
    if(Get.arguments?['data']!=null){
      model.value = Get.arguments['data'];
      title = model.value?.name??"";
    }
  }
}
