import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/home/item.dart';

import 'logic.dart';
import 'state.dart';

class SettingSubPage
    extends BaseGetListPageView<SettingSubController, SettingSubState> {
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
    return GridView.builder(
      controller: state.scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4),
      itemBuilder: (context, index) {
        var item = settingCtrl.menuItems[index];
        return GridItem(adapter: ListAdapter(
            title: item.title,
            labels:[item.shortcut.label] ,
            image: item.shortcut.icon,
            callback: () {
              settingCtrl.showAddFeatures(item);
            }
        ));
      }, itemCount: settingCtrl.menuItems.length,);
  }

  Widget allWidget() {
    return Obx(() {
      return ListView.builder(
        controller: state.scrollController,
        itemBuilder: (BuildContext context, int index) {
          var item = state.nav.value!.children[index];
          return Item(
            item: item,
            onTap: () {
              controller.jumpDetails(item);
            },
            onNext: () {
              controller.onNextLv(item);
            },
            onSelected: (key, item) {
              controller.operation(key, item);
            },
          );
        },
        itemCount: state.nav.value!.children.length,
      );
    });
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

  @override
  bool displayNoDataWidget() => false;
}
