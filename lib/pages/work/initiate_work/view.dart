import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';

import 'logic.dart';
import 'state.dart';

class InitiateWorkPage extends BaseBreadcrumbNavMultiplexPage<
    InitiateWorkController, InitiateWorkState> {
  InitiateWorkPage({super.key});

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Obx(() {
        List<Widget> children = [];
        for (var child in state.model.value!.children) {
          children.add(
            BaseBreadcrumbNavItem(
              item: child,
              onTap: () {
                controller.jumpWorkList(child);
              },
              onNext: () {
                controller.jumpNext(child);
              },
            ),
          );
        }
        return Column(
          children: children,
        );
      }),
    );
  }

  @override
  InitiateWorkController getController() {
    return InitiateWorkController();
  }

  @override
  String tag() {
    return hashCode.toString();
  }
}
