


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  List<PopupMenuItem> popupItems() {
    // TODO: implement popupItems
    return [ PopupMenuItem(value: PopupMenuKey.shareQr,child: Text(PopupMenuKey.shareQr.label),)];
  }

  @override
  void onSelectPopupItem(key) {
    onSelected?.call(key,item);
  }

  @override
  Widget more() {
    if (item.spaceEnum == SpaceEnum.file ||
        item.spaceEnum == SpaceEnum.species ||
        item.spaceEnum == SpaceEnum.work ||
        item.spaceEnum == SpaceEnum.property) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.navigate_next,
        size: 32.w,
      ),
    );
  }
}