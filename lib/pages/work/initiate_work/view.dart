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
        List<Widget> children = [];
        if (state.model.value!.name == "发起办事") {
          children = initiate();
        }else{
          children = workDetails();
        }
        return Column(
          children: children,
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
            return InitiateWorkItem(
              item: e,
              showCreateIcon:  e.workEnum == WorkEnum.initiationWork,
              onTap: () {
                controller.jumpWorkList(e);
              },
              onNext: (){
                controller.jumpNext(e);
              },
              onCreateWork: (){
                controller.createWork(e);
              },
            );
          }).toList(),
        ],
      ));
    }
    return children;
  }

  List<Widget> workDetails() {
    List<Widget> children = [];
    for (var child in state.model.value!.children) {
      children.add(
        InitiateWorkItem(
          item: child,
          showCreateIcon: child.workEnum == WorkEnum.initiationWork,
          onTap: () {
            controller.jumpWorkList(child);
          },
          onNext: (){
            controller.jumpNext(child);
          },
          onCreateWork: (){
            controller.createWork(child);
          },
        ),
      );
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
