import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';

import 'breadcrumb_nav_instance.dart';

abstract class BaseBreadcrumbNavController<S extends BaseBreadcrumbNavState>
    extends BaseController<S> {


  BaseBreadcrumbNavController();

  BaseBreadcrumbNavController? previous;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    previous = BreadcrumbNavInstance().previous();
    state.bcNav.add(
        BaseBreadcrumbNavInfo(title: state.title, data: state.model.value));
    if (previous != null) {
      for (int i = previous!.state.bcNav.length - 1; i >= 0; i--) {
        state.bcNav.insert(0, previous!.state.bcNav[i]);
      }
    }
  }

  //刷新上一页数据
  void updateNav() {
    state.bcNav.last.title = state.model.value!.name;
    state.bcNav.refresh();
    try{
      previous?.state.model.refresh();
    }catch(e){

    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    BreadcrumbNavInstance().put(this, tag: tag);

    var maxPosition = state.navBarController.position.maxScrollExtent;

    state.navBarController.animateTo(maxPosition,
        duration: const Duration(microseconds: 300), curve: Curves.linear);
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
      var name = (route.settings.arguments as Map)['data']?.name??"";
      var id = (route.settings.arguments as Map)['data']?.id??"";
      if(name == ''){
        return Get.currentRoute == routerName;
      }
      return Get.currentRoute == routerName && state.bcNav[index].data?.name == name && state.bcNav[index].data?.id == id;
    },);
  }

  void popAll(){
    pop(0);
    Get.back();
  }


  void onTopPopupMenuSelected(PopupMenuKey key){

  }

  void search(str){
    state.keyword.value = str;
  }

  void changeSearchState(){
    state.showSearch.value = !state.showSearch.value;
    if(!state.showSearch.value){
      state.keyword.value = '';
    }
  }

  void back(){
    Get.back();
  }
}
