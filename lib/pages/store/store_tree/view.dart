import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'logic.dart';
import 'state.dart';
import 'store_nav_item.dart';
class StoreTreePage
    extends BaseBreadcrumbNavMultiplexPage<
        StoreTreeController,
        StoreTreeState> {


  @override
  Widget body() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          children: details()
        );
      }),
    );
  }

  List<Widget> details() {
    return state.model.value!.children.map((e) {
      return StoreNavItem(
        item: e,
        onNext: () {
          controller.onNext(e);
        },
        onSelected: (key,item){
          controller.operation(key, item);
        },
      );
    }).toList();
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
}