import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/widget/common_widget.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class InitiateWorkPage extends BaseBreadcrumbNavMultiplexPage<
    InitiateWorkController, InitiateWorkState> {
  @override
  Widget body() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          children: initiate(),
        );
      }),
    );
  }

  List<Widget> initiate() {
    List<Widget> children = [];
    for (var child in state.model.value!.children) {
      children.add(Column(
        children: [
          CommonWidget.commonHeadInfoWidget(child.name),
          ...child.children.map((e) {
            return BaseBreadcrumbNavItem(
              item: e,
              onTap: () {
                controller.jumpWorkList(e);
              },
              onNext: (){
                controller.jumpNext(e);
              },
            );
          }).toList(),
        ],
      ));
    }
    return children;
  }


  @override
  InitiateWorkController getController() {
    return InitiateWorkController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }
}
