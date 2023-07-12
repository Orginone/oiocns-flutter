import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Obx(() {
              var children = state.model.value!.children
                  .where(
                      (element) => element.name.contains(state.keyword.value))
                  .toList();
              return Column(
                children: children
                    .map((e) => Item(
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
        state.isRootDir
            ? SizedBox(
                child: CommonWidget.commonSubmitWidget(
                    text: "退出登录",
                    submit: () {
                      controller.jumpLogin();
                    },
                    image: Images.logOut),
              )
            : const SizedBox(),
      ],
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

  @override
  List<PopupMenuItem<PopupMenuKey>> popupMenuItems() {
    if (state.model.value!.source == null && state.model.value!.space == null ||
        state.model.value!.spaceEnum == null) {
      return super.popupMenuItems();
    }

    try {
      List<PopupMenuItem<PopupMenuKey>> popup =
          state.model.value!.source?.popupMenuItem ??
              state.model.value!.space!.popupMenuItem;
      return popup;
    } catch (e) {
      return super.popupMenuItems();
    }
  }
}
