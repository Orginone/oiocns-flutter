import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/pages/setting/config.dart';

import 'popup_menu_widget.dart';
import 'setting/state.dart';

class Item extends BaseBreadcrumbNavItem<SettingNavModel> {
  final PopupMenuItemSelected? onSelected;
  const Item(
      {Key? key,
        this.onSelected, required super.item,super.onNext,super.onTap});



  @override
  Widget action() {
    // TODO: implement action
    return PopupMenuWidget(
      onSelected:onSelected, model: item,
    );
  }
}
