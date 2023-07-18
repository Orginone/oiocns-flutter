import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/home/item.dart';

import 'logic.dart';
import 'state.dart';

class SettingSubPage
    extends BaseGetPageView<SettingSubController, SettingSubState> {
  late String type;

  SettingSubPage(this.type);

  @override
  Widget buildView() {
    if (type == 'all') {
      return allWidget();
    }
    if (type == 'common') {
      return commonWidget();
    }
    return Container();
  }

  Widget commonWidget() {
    return Column(
      children: settingCtrl.menuItems.map((e) {
        return ListItem(adapter: ListAdapter(
          title: e.title,
          content: e.shortcut.label,
          image: e.shortcut.icon,
          callback: (){
            settingCtrl.showAddFeatures(e);
          }
        ));
      }).toList(),
    );
  }

  Widget allWidget() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          children: state.nav.value!.children
              .map((e) => Item(
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
  SettingSubController getController() {
    return SettingSubController(type);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "setting_$type";
  }
}
