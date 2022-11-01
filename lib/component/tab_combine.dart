import 'package:flutter/material.dart';

import 'bread_crumb.dart';

const defaultIconMargin = EdgeInsets.all(4);

class TabCombine {
  final Widget? body;
  final Widget tabView;
  final IconData? icon;
  final EdgeInsets? iconMargin;
  final Item<String>? breadCrumbItem;

  const TabCombine({
    Key? key,
    required this.tabView,
    this.body,
    this.icon,
    this.iconMargin = defaultIconMargin,
    this.breadCrumbItem,
  });

  Tab toTab() {
    return Tab(
      iconMargin: iconMargin!,
      icon: icon == null ? null : Icon(icon),
      child: body,
    );
  }
}
