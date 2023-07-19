import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/main.dart';

import 'logic.dart';
import 'state.dart';

class WorkSubPage extends BaseGetListPageView<WorkSubController, WorkSubState> {
  late String type;

  WorkSubPage(this.type);

  @override
  Widget buildView() {
    if (type == 'all') {
      return allWidget();
    }
    if (type == 'create') {
      return applicationWidget();
    }
    if (type == 'common') {
      return commonWidget();
    }
    if (type == 'todo') {
      return todoWidget();
    }
    return otherWidget();
  }

  Widget otherWidget(){
    return Obx((){
      return ListView.builder(
        controller: state.scrollController,
        itemBuilder: (context, index) {
          var work = state.list[index];

          return ListItem(adapter: ListAdapter.work(work));
        },
        itemCount: state.list.length,
      );
    });
  }



  Widget todoWidget(){
    return Obx((){
      return ListView.builder(
        controller: state.scrollController,
        itemBuilder: (context, index) {
          var work = settingCtrl.work.todos[index];

          return ListItem(adapter: ListAdapter.work(work));
        },
        itemCount: settingCtrl.work.todos.length,
      );
    });
  }


  Widget commonWidget(){
    return Obx(() {
      return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        controller: state.scrollController,
        itemBuilder: (context, index) {
          var app = settingCtrl.work.workFrequentlyUsed[index];

          var adapter = ListAdapter(
            title: app.define.metadata.name ?? "",
            image: Ionicons.apps_sharp,
            labels: [app.define.metadata.typeName ?? ""],
          );

          adapter.popupMenuItems = [
            PopupMenuItem(
              value: PopupMenuKey.removeCommon,
              child: Text(PopupMenuKey.removeCommon.label),
            )
          ];
          adapter.onSelected = (key) {
            controller.onSelected(key, app);
          };

          return GridItem(
              adapter: adapter);
        },
        itemCount: settingCtrl.work.workFrequentlyUsed.length,
      );
    });
  }


  Widget applicationWidget(){
    return Obx((){
      return GridView.builder(
        controller: state.scrollController,
        itemBuilder: (context, index) {
          var app = settingCtrl.provider.myApps[index];

          return GridItem(
            adapter: ListAdapter.application(app.keys.first, app.values.first),
          );
        },
        itemCount: settingCtrl.provider.myApps.length, 
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      );
    });
  }


  Widget allWidget() {
    return ListView.builder(
      controller: state.scrollController,
      itemBuilder: (BuildContext context, int index) {
        var item = state.nav!.children[index];
        return BaseBreadcrumbNavItem(
          item: item,
          onTap: () {
            controller.jumpWorkList(item);
          },
          onNext: () {
            controller.jumpNext(item);
          },
        );
      },itemCount: state.nav!.children.length,);
  }

  @override
  WorkSubController getController() {
    return WorkSubController(type);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "work_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}