


import 'dart:convert';

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

    if(item.spaceEnum == SpaceEnum.file){
      return Obx(() {
        List<PopupMenuKey> keys = [PopupMenuKey.shareQr];
        if (settingCtrl.store.isMostUsed(item.id)) {
          keys.add(PopupMenuKey.removeCommon);
        } else {
          keys.add(PopupMenuKey.setCommon);
        }
        return CommonWidget.commonPopupMenuButton<PopupMenuKey>(
          items: keys.map((e) => PopupMenuItem(value: e,child: Text(e.label),)).toList(),
          onSelected: (key) {
            onSelected?.call(key,item);
          },);
      });
    }
    return CommonWidget.commonPopupMenuButton<PopupMenuKey>(
      items: [
        PopupMenuItem(value: PopupMenuKey.shareQr,child: Text(PopupMenuKey.shareQr.label),)
      ],
      onSelected: (key) {
        onSelected?.call(key,item);
      },);
  }


}