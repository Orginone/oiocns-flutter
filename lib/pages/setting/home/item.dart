import 'package:flutter/material.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/widget/common_widget.dart';

import 'state.dart';

class Item extends BaseBreadcrumbNavItem<SettingNavModel> {
  final void Function(PopupMenuKey value,SettingNavModel model)? onSelected;
  const Item(
      {Key? key,
        this.onSelected, required super.item,super.onNext,super.onTap});


  @override
  Widget action() {
    // TODO: implement action
    if(item.source == null && item.space == null || item.spaceEnum == null){
      return super.action();
    }

    try{
      List<PopupMenuItem<PopupMenuKey>> popup = item.source?.popupMenuItem??item.space!.popupMenuItem;
      return CommonWidget.commonPopupMenuButton<PopupMenuKey>(items:popup ,onSelected:(key){
        onSelected?.call(key,item);
      });
    }catch(e){
      return super.action();
    }
  }
}

