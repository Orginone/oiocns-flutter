import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/utils/index.dart';

import 'logic.dart';
import 'state.dart';
import 'store_nav_item.dart';

///目录层级界面  树形
class StoreTreePage extends BaseBreadcrumbNavMultiplexPage<StoreTreeController,
    StoreTreeState> {
  StoreTreePage({super.key});

  @override
  Widget body() {
    return Obx(() {
      LogUtil.d('StoreTreePage');
      var children = state.model.value!.children
          .where((element) => element.name.contains(state.keyword.value))
          .toList();
      return ListView.builder(
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            var item = children[index];
            return StoreNavItem(
              item: item,
              onTap: () {
                controller.jumpDetails(item);
              },
              onNext: () {
                controller.onNext(item);
              },
              onSelected: (key, item) {
                controller.operation(key, item);
              },
            );
          });
    });
  }

  @override
  StoreTreeController getController() {
    return StoreTreeController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }

  @override
  List<PopupMenuItem<PopupMenuKey>> popupMenuItems() {
    if (state.model.value!.spaceEnum == SpaceEnum.directory &&
        state.model.value!.source == null) {
      return super.popupMenuItems();
    }

    List<PopupMenuKey> items = [PopupMenuKey.shareQr];
    return items
        .map((e) => PopupMenuItem(
              value: e,
              child: Text(e.label),
            ))
        .toList();
  }
}
