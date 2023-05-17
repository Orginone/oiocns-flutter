import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_page.dart';
import 'package:orginone/pages/setting/config.dart';

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
                    if(e.spaceEnum!=null){
                      controller.createOrganization(e);
                    }else if(e.standardEnum!=null){
                      switch(e.standardEnum){
                        case StandardEnum.permission:
                          controller.createAuth(e);
                          break;
                        case StandardEnum.classCriteria:
                          controller.createClassCriteria(e);
                          break;
                      }
                    }

                    break;
                  case "edit":
                    if(e.spaceEnum!=null){
                      controller.createOrganization(e,isEdit: true);
                    }
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