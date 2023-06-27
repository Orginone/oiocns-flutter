


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/common_widget.dart';

import 'state.dart';

class StoreNavItem extends BaseBreadcrumbNavItem<StoreTreeNav>{
  final void Function(PopupMenuKey value,StoreTreeNav model)? onSelected;
  StoreNavItem({required super.item,super.onTap,super.onNext,this.onSelected});



  @override
  Widget action() {
    if(item.source!=null&&item.spaceEnum == SpaceEnum.file){
      return Obx(() {
        PopupMenuItem<PopupMenuKey> popupMenuItem;
        if (settingCtrl.store.isMostUsed(item.id)) {
          popupMenuItem = PopupMenuItem(
            value: PopupMenuKey.removeCommon,
            child: Text(PopupMenuKey.removeCommon.label),
          );
        } else {
          popupMenuItem =  PopupMenuItem(
            value: PopupMenuKey.setCommon,
            child: Text(PopupMenuKey.setCommon.label),
          );
        }
        return CommonWidget.commonPopupMenuButton<PopupMenuKey>(
            items: [
              popupMenuItem,
            ],
            onSelected: (key) {
              onSelected?.call(key,item);
            },);
      });
    }
    return super.action();
  }


}