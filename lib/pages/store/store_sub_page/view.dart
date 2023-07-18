import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/store_tree/store_nav_item.dart';

import 'logic.dart';
import 'state.dart';

class StoreSubPage extends BaseGetPageView<StoreSubController,StoreSubState>{

  late String type;

  StoreSubPage(this.type);

  @override
  Widget buildView() {
    if(type == "all"){
      return allWidget();
    }
    if(type == "common"){
      return commonWidget();
    }
    return recentWidget(type: type);
  }


  Widget allWidget(){
    return SingleChildScrollView(
      child: Column(
        children: state.nav!.children.map((e) {
          return StoreNavItem(
            item: e,
            onTap: () {
              controller.jumpDetails(e);
            },
            onNext: () {
              controller.onNext(e);
            },
            onSelected: (key, item) {
              controller.operation(key, item);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget commonWidget(){
    return Obx((){
      return ListView.builder(
        itemBuilder: (context, index) {
          var store = settingCtrl.store.storeFrequentlyUsed[index];

          return ListItem(adapter: ListAdapter(
            title: store.name??"",
            image: store.fileItemShare?.thumbnailUint8List??Ionicons.clipboard_sharp,
            content: store.storeEnum.label,
          ));
        },
        itemCount:  settingCtrl.store.storeFrequentlyUsed.length,
      );
    });
  }


  Widget recentWidget({String type = "file"}){
    return Obx((){
      var data = settingCtrl.store.recent.where((p0) => p0.type == type).toList();

      return ListView.builder(
        itemBuilder: (context, index) {
          var store = data[index];
          return ListItem(adapter: ListAdapter.store(store));
        },
        itemCount: data.length,
      );
    });
  }

  @override
  StoreSubController getController() {
    return StoreSubController(type);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "store_$type";
  }
}