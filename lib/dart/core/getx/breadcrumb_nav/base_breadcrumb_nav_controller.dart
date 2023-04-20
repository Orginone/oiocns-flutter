import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/routers.dart';

import '../base_bindings.dart';
import 'breadcrumb_nav_instance.dart';

abstract class BaseBreadcrumbNavController<S extends BaseBreadcrumbNavState>
    extends BaseController<S> {


  String? tag;

  BaseBreadcrumbNavController({this.tag});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var previous = BreadcrumbNavInstance().previous()?.state.bcNav;
    state.bcNav.add(BaseBreadcrumbNavInfo(title: state.title,data: state.model));
    if (previous != null) {
      for (int i = previous.length - 1; i >= 0 ; i--) {
        state.bcNav
            .insert(0, BreadcrumbNavInstance().previous()!.state.bcNav[i]);
      }
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    BreadcrumbNavInstance().put(this,tag: tag);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    BreadcrumbNavInstance().pop();
    super.onClose();
  }

  void pop(int index) {
    String routerName = state.bcNav[index].route;
    Get.until((route){
      if(route.settings.arguments==null){
        return Get.currentRoute == routerName;
      }
      var name = (route.settings.arguments as Map)['data'].name;
      return Get.currentRoute == routerName && state.bcNav[index].data?.name == name;
    },);
  }

  void popAll(){
    Get.until((route){
      return Get.currentRoute == Routers.home;
    },);
  }
}
