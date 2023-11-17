// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';

import 'logic.dart';
import 'state.dart';

///办事tab页面
class WorkSubPage extends BaseGetListPageView<WorkSubController, WorkSubState> {
  final String type;

  WorkSubPage(this.type, {super.key});

  @override
  Widget buildView() {
    if (type == 'all') {
      return allWidget();
    }

    // if (type == 'create') {
    //   return applicationWidget();
    // }
    if (type == 'common') {
      return commonWidget();
    }
    if (type == 'todo') {
      return todoWidget();
    }
    return otherWidget();
  }

  Widget otherWidget() {
    return Obx(() {
      return state.list.isEmpty
          ? _emptyView()
          : ListView.builder(
              shrinkWrap: true,
              controller: state.scrollController,
              itemBuilder: (context, index) {
                var work = state.list[index];

                return ListItem(adapter: ListAdapter.work(work));
              },
              itemCount: state.list.length,
            );
    });
  }

  Widget todoWidget() {
    return Obx(() {
      return state.list.isEmpty
          ? _emptyView()
          : ListView.builder(
              shrinkWrap: true,
              controller: state.scrollController,
              itemBuilder: (context, index) {
                // var work = settingCtrl.work.todos[index];
                var work = state.list[index];

                return ListItem(adapter: ListAdapter.work(work));
              },
              // itemCount: settingCtrl.work.todos.length,
              itemCount: state.list.length,
            );
    });
  }

  Widget commonWidget() {
    return Obx(() {
      return settingCtrl.work.todos.isEmpty
          ? _emptyView()
          : GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              controller: state.scrollController,
              itemBuilder: (context, index) {
                //TODO:workFrequentlyUsed 方法删除  暂时用一个  后面再看逻辑
                var app = settingCtrl.work.tasks[index];

                var adapter = ListAdapter(
                  title: '222', // app.define.metadata.name ?? "",
                  image: Ionicons.apps_sharp,
                  labels: [], //[app.define.metadata.typeName ?? ""],
                );

                adapter.popupMenuItems = [
                  PopupMenuItem(
                    value: PopupMenuKey.removeCommon,
                    child: Text(PopupMenuKey.removeCommon.label),
                  )
                ];
                adapter.onSelected = (key) {
                  // controller.onSelected(key, app);
                };

                return GridItem(adapter: adapter);
              },
              itemCount: settingCtrl.work.todos.length,
            );
    });
  }

  Widget applicationWidget() {
    return Obx(() {
      return settingCtrl.provider.myApps.isEmpty
          ? _emptyView()
          : GridView.builder(
              shrinkWrap: true,
              controller: state.scrollController,
              itemBuilder: (context, index) {
                var app = settingCtrl.provider.myApps[index];

                return GridItem(
                  adapter:
                      ListAdapter.application(app.keys.first, app.values.first),
                );
              },
              itemCount: settingCtrl.provider.myApps.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
            );
    });
  }

  Widget allWidget() {
    return state.nav!.children.isEmpty
        ? _emptyView()
        : ListView.builder(
            controller: state.scrollController,
            itemBuilder: (BuildContext context, int index) {
              var item = state.nav!.children[index];
              return BaseBreadcrumbNavItem(
                item: item,
                onTap: () {
                  controller.jumpWorkList(item);
                },
                onNext: () {
                  ///全部办事 点击事件
                  controller.jumpNext(item);
                },
              );
            },
            itemCount: state.nav?.children.length ?? 0,
          );
  }

  Widget _emptyView() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        "暂无数据",
        style: XFonts.size20Black9,
      ),
    );
  }

  @override
  WorkSubController getController() {
    return WorkSubController(type);
  }

  @override
  String tag() {
    return "work_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}
