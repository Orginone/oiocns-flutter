import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';

import 'state.dart';

class Item extends BaseBreadcrumbNavItem<GeneralBreadcrumbNav> {
  final void Function(PopupMenuKey value, GeneralBreadcrumbNav model)?
      onSelected;

  const Item(
      {super.key,
      required super.item,
      super.onNext,
      super.onTap,
      this.onSelected});

  @override
  List<PopupMenuItem> popupItems() {
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
    return [popupMenuItem];
  }

  @override
  void onSelectPopupItem(key) {
    onSelected?.call(key, item);
  }
}
