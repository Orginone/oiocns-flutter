import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';

import 'logic.dart';
import 'state.dart';

class MarketTreePage
    extends BaseBreadcrumbNavMultiplexPage<MarketTreeController,
        MarketTreeState> {

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          children: state.model.value?.children.map((e) {
            return BaseBreadcrumbNavItem<BaseBreadcrumbNavModel>(
              item: e,
              onTap: () {
                controller.jumpDetails(e);
              },
              onNext: () {
                controller.onNext(e);
              },
            );
          }).toList() ?? [],
        );
      }),
    );
  }

  @override
  MarketTreeController getController() {
    return MarketTreeController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }
}