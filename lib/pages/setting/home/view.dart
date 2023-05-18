import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_page.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/widget/common_widget.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class SettingCenterPage
    extends BaseBreadcrumbNavMultiplexPage<SettingCenterController, SettingCenterState> {

  @override
  Widget body() {
    return Obx((){
      return state.model.value?.name == "设置"?home():details();
    });
  }

  Widget home() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: state.model.value!.children
                  .map((e) => BaseBreadcrumbNavItem(
                        item: e,
                        onTap: () {
                          controller.jumpInfo(e);
                        },
                        onNext: () {
                          controller.onHomeNextLv(e);
                        },
                      ))
                  .toList(),
            ),
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


  Widget details(){
    return SingleChildScrollView(
      child: Column(
        children: state.model.value?.children.map((e) {
          return Item(
            onNext: () {
              controller.onDetailsNextLv(e);
            },
            onTap: (){
              controller.jumpDetails(e);
            },
            onSelected: (value) {
              switch(e.standardEnum){
                case StandardEnum.permission:
                  controller.operationPermission(e,value);
                  break;
                case StandardEnum.classCriteria:
                  controller.operationClassCriteria(e,value);
                  break;
                case StandardEnum.propPackage:
                  controller.operationPropPackage(e,value);
                  break;
                default:
                  controller.operationGroup(e,value);
                  break;
              }
            },
            item: e,
          );
        }).toList() ??
            [],
      ),
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
