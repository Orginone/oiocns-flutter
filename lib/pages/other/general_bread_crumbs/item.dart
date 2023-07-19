


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/common_widget.dart';

import 'state.dart';

class Item extends BaseBreadcrumbNavItem<GeneralBreadcrumbNav>{

  final void Function(PopupMenuKey value,GeneralBreadcrumbNav model)? onSelected;

  Item({required super.item,super.onNext,super.onTap,this.onSelected});


  List<PopupMenuItem> popupItems(){
    if (item.spaceEnum != SpaceEnum.work) {
      return super.popupItems();
    }
    PopupMenuItem<PopupMenuKey> popupMenuItem;
    if (settingCtrl.work.isMostUsed(item.source!)) {
      popupMenuItem = const PopupMenuItem(
        value: PopupMenuKey.removeCommon,
        child: Text("移除常用"),
      );
    } else {
      popupMenuItem = const PopupMenuItem(
        value: PopupMenuKey.setCommon,
        child: Text("设为常用"),
      );
    }
    return [
      popupMenuItem
    ];
  }

  @override
  void onSelectPopupItem(key) {
    onSelected?.call(key,item);
  }
}