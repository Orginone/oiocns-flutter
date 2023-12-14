// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/index.dart';

import 'logic.dart';
import 'state.dart';

///办事tab页面
class WorkSubPage extends BaseGetListPageView<WorkSubController, WorkSubState> {
  final String type;

  WorkSubPage(this.type, {super.key});

  @override
  Widget buildView() {
    // if (type == 'common') {
    //   return commonWidget();
    // }
    if (type == 'todo') {
      return todoWidget();
    }
    return otherWidget();
  }

  Widget otherWidget() {
    return Obx(() {
      if (state.list.isEmpty) {
        return emptyView();
      }
      return ListView.builder(
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
      if (settingCtrl.work.todos.isEmpty) {
        return emptyView();
      }

      return ListView.builder(
        shrinkWrap: true,
        controller: state.scrollController,
        itemBuilder: (context, index) {
          var work = settingCtrl.work.todos[index];
          return ListItem(adapter: ListAdapter.work(work));
        },
        itemCount: settingCtrl.work.todos.length,
      );
    });
  }

  Widget emptyView() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height.w,
        alignment: Alignment.center,
        color: Colors.white,
        child: Image.asset(AssetsImages.empty, width: 200.w),
      ),
    );
  }
  // Widget commonWidget() {
  //   return Obx(() {
  //     return GridView.builder(
  //       shrinkWrap: true,
  //       gridDelegate:
  //           const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
  //       controller: state.scrollController,
  //       itemBuilder: (context, index) {
  //         //TODO:workFrequentlyUsed 方法删除  暂时用一个  后面再看逻辑
  //         var app = settingCtrl.work.tasks[index];

  //         var adapter = ListAdapter(
  //           title: '222', // app.define.metadata.name ?? "",
  //           image: Ionicons.apps_sharp,
  //           labels: [], //[app.define.metadata.typeName ?? ""],
  //         );

  //         adapter.popupMenuItems = [
  //           PopupMenuItem(
  //             value: PopupMenuKey.removeCommon,
  //             child: Text(PopupMenuKey.removeCommon.label),
  //           )
  //         ];
  //         adapter.onSelected = (key) {
  //           // controller.onSelected(key, app);
  //         };

  //         return GridItem(adapter: adapter);
  //       },
  //       itemCount: settingCtrl.work.todos.length,
  //     );
  //   });
  // }

  // Widget applicationWidget() {
  //   return Obx(() {
  //     return GridView.builder(
  //       shrinkWrap: true,
  //       controller: state.scrollController,
  //       itemBuilder: (context, index) {
  //         var app = settingCtrl.provider.myApps[index];

  //         return GridItem(
  //           adapter: ListAdapter.application(app.keys.first, app.values.first),
  //         );
  //       },
  //       itemCount: settingCtrl.provider.myApps.length,
  //       gridDelegate:
  //           const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
  //     );
  //   });
  // }

  @override
  WorkSubController getController() {
    return WorkSubController(type);
  }

  @override
  String tag() {
    LogUtil.d('type');
    LogUtil.d(type);
    return "work_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}
