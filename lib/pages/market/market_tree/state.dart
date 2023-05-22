


import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';

class MarketTreeState extends BaseBreadcrumbNavState{


  MarketTreeState(){
    model.value = Get.arguments?['data'];
    title = model.value?.name??HomeEnum.market.label;
  }
}