import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/common_widget.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class SettingCenterPage extends BaseBreadcrumbNavMultiplexPage<
    SettingCenterController,
    SettingCenterState> {

  @override
  Widget body() {
    return state.isRootDir ? home() : details();
  }

  Widget home() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Obx(() {
              return Column(
                children: state.model.value!.children
                    .map((e) =>
                    Item(
                      item: e,
                      onTap: () {
                        controller.jumpInfo(e);
                      },
                      onNext: () {
                        controller.onHomeNextLv(e);
                      },
                      onSelected: (key, item) {
                        controller.operation(key, item);
                      },
                    ))
                    .toList(),
              );
            }),
          ),
        ),
        SizedBox(
          child: CommonWidget.commonSubmitWidget(
              text: "退出登录",
              submit: () {
                controller.jumpLogin();
              },
              image: Images.logOut),
        ),
      ],
    );
  }


  Widget details() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          children: state.model.value?.children.map((e) {
            return Item(
              onNext: () {
                controller.onDetailsNextLv(e);
              },
              onTap: () {
                controller.jumpDetails(e);
              },
              onSelected: (key, item) {
                controller.operation(key, item);
              },
              item: e,
            );
          }).toList() ??
              [],
        );
      }),
    );
  }

  @override
  SettingCenterController getController() {
    return SettingCenterController();
  }

  @override
  String tag() {
    return hashCode.toString();
  }
}
