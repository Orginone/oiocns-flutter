

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';

class UniversalNavigatorState extends BaseGetState{

  late String title;

  var sourceData = <NavigatorModel>[].obs;

  var selectedData = <NavigatorModel>[].obs;

  List<PopupMenuItem<NavigatorPopupMenuEnum>> popupMenuItem = [];

  List<Widget> action = [];

  UniversalNavigatorState(){
    title = Get.arguments?['title']??"";
    sourceData.addAll(Get.arguments?['data']??[]);
    if(Get.arguments?['popupMenuItem']!=null){
      popupMenuItem.addAll(Get.arguments['popupMenuItem']);
    }
    if(Get.arguments?['action']!=null){
      action.addAll(Get.arguments['action']);
    }
  }

}


class NavigatorModel{
  late String id;
  late String title;
  late List<NavigatorModel> children;
  dynamic source;

  NavigatorModel(
      {this.id = '', this.title = '', this.children = const [], this.source});

  NavigatorModel.formSpecies(ISpeciesItem iSpeciesItem) {
    id = iSpeciesItem.id;
    title =  iSpeciesItem.name;
    children =   getSpeciesChildren(iSpeciesItem.children);
    source = iSpeciesItem;
  }

  List<NavigatorModel> getSpeciesChildren(List<ISpeciesItem> iSpeciesItems) {
    List<NavigatorModel> children = [];
    if(iSpeciesItems.isEmpty){
      return children;
    }
    for (var element in iSpeciesItems) {
      children.add(NavigatorModel(
          id: element.id,
          title: element.name,
          children: getSpeciesChildren(element.children),
          source: element));
    }
    return children;
  }
}

enum NavigatorPopupMenuEnum{
  create,
  add,
}