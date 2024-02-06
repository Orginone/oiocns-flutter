import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/relation/home/item.dart';
import 'package:orginone/pages/relation/home/logic.dart';
import 'state.dart';

class RelationCenterPage extends BaseBreadcrumbNavMultiplexPage<
    RelationCenterController, RelationCenterState> {
  RelationCenterPage({super.key});

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Obx(() {
        var children = state.model.value!.children
            .where((element) => element.name.contains(state.keyword.value))
            .toList();
        return Column(
          children: children
              .map((e) => RelationItem(
                    item: e,
                    onTap: () {
                      controller.jumpDetails(e);
                    },
                    onNext: () {
                      controller.onNextLv(e);
                    },
                    onSelected: (key, item) {
                      controller.operation(key, item);
                    },
                  ))
              .toList(),
        );
      }),
    );
  }

  @override
  RelationCenterController getController() {
    return RelationCenterController();
  }

  @override
  String tag() {
    return hashCode.toString();
  }

  @override
  List<PopupMenuItem<PopupMenuKey>> popupMenuItems() {
    if (state.model.value!.spaceEnum == SpaceEnum.person) {
      List<PopupMenuKey> keys = [
        PopupMenuKey.addPerson,
        PopupMenuKey.permission,
        PopupMenuKey.role,
      ];
      if (!relationCtrl.isUserSpace(state.model.value!.space!)) {
        keys.add(PopupMenuKey.station);
      }
      return keys
          .map((e) => PopupMenuItem(
                value: e,
                child: Text(e.label),
              ))
          .toList();
    }

    if (state.model.value!.source == null && state.model.value!.space == null ||
        state.model.value!.spaceEnum == null) {
      return super.popupMenuItems();
    }

    try {
      List<PopupMenuItem<PopupMenuKey>> popup =
          state.model.value!.source?.popupMenuItem; //??
      // state.model.value!.space!.popupMenuItem;
      return popup;
    } catch (e) {
      return super.popupMenuItems();
    }
  }
}
