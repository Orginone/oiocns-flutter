import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_page.dart';

import '../item.dart';
import 'logic.dart';
import 'state.dart';


class SettingFunctionPage extends BaseBreadcrumbNavMultiplexPage<
    SettingFunctionController, SettingFunctionState> {
  @override
  Widget body() {
    return Column(
      children: state.model.value?.children.map((e) {
            return Item(
              onNext: () {
                controller.nextLvForSpaceEnum(e);
              },
              onSelected: (value) {
                switch (value) {
                  case "create":
                    controller.createOrganization(e);
                    break;
                  case "edit":
                    controller.editOrganization(e);
                    break;
                }
              },
              item: e,
            );
          }).toList() ??
          [],
    );
  }

  @override
  SettingFunctionController getController() {
   return SettingFunctionController();
  }
  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }

}