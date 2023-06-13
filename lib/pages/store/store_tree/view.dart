import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/widget/common_widget.dart';
import 'logic.dart';
import 'state.dart';

class StoreTreePage
    extends BaseBreadcrumbNavMultiplexPage<
        StoreTreeController,
        StoreTreeState> {


  @override
  Widget body() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          children: state.model.value?.name == HomeEnum.store.label
              ? home()
              : details(),
        );
      }),
    );
  }


  List<Widget> home() {
    List<Widget> children = [];
    for (var child in state.model.value!.children) {
      children.add(Column(
        children: [
          CommonWidget.commonHeadInfoWidget(child.name),
          ...child.children.map((e) {
            return BaseBreadcrumbNavItem<StoreTreeNav>(
              item: e,
              onTap: () {
              },
              onNext: () {
                controller.onNext(e);
              },
            );
          }).toList(),
        ],
      ));
    }
    return children;
  }

  List<Widget> details() {
    return state.model.value!.children.map((e) {
      return BaseBreadcrumbNavItem<StoreTreeNav>(
        item: e,
        onTap: () {
          controller.jumpDetails(e);
        },
        onNext: () {
          controller.onNext(e);
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