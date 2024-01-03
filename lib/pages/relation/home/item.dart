import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/public/enums.dart';

import 'state.dart';

class RelationItem extends BaseBreadcrumbNavItem<RelationNavModel> {
  final void Function(PopupMenuKey value, RelationNavModel model)? onSelected;
  const RelationItem(
      {super.key,
      this.onSelected,
      required super.item,
      super.onNext,
      super.onTap});

  @override
  List<PopupMenuItem> popupItems() {
    if (item.source == null && item.space == null || item.spaceEnum == null) {
      return super.popupItems();
    }
    List<PopupMenuItem<PopupMenuKey>> popup =
        item.source?.popupMenuItem; //?? item.space!.popupMenuItem;
    return popup;
  }

  @override
  void onSelectPopupItem(key) {
    onSelected?.call(key, item);
  }
}
