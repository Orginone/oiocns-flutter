

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/pages/setting/home/setting/state.dart';

class RelationGroupState extends BaseBreadcrumbNavState<SettingNavModel>{


  bool get isStandard => model.value?.standardEnum!=null;

  RelationGroupState(){
    if(Get.arguments?['data']!=null){
      model.value = Get.arguments['data'];
      title = model.value?.name??"";
    }
  }
}
