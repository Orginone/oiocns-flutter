import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/widget/common_widget.dart';
import '../item.dart';
import 'logic.dart';
import 'state.dart';

SettingController get setting => Get.find<SettingController>();

class RelationPage extends BaseGetPageView<RelationController,RelationState>{
  @override
  Widget buildView() {
    return Column(
      children: [
        CommonWidget.commonBreadcrumbNavWidget(
          firstTitle: "关系",
          allTitle: [],
        ),
        Expanded(child: list())
      ],
    );
  }

  Widget list() {
    return Obx(() {
      if(setting.isCompanySpace()){
        return Column(
          children: CompanySpaceEnum.values
              .map((e) =>
              Item(
                companySpaceEnum: e,
                nextLv: () {
                  controller.nextLvForEnum(companySpaceEnum: e);
                },
                onSelected: (value){
                  switch(value){
                    case "create":
                      controller.createOrganization(companySpaceEnum: e);
                      break;
                    case "edit":
                      controller.editOrganization(companySpaceEnum: e);
                      break;
                  }
                },
              ))
              .toList(),
        );
      }else{
        return Column(
          children: UserSpaceEnum.values
              .map((e) =>
              Item(
                userSpaceEnum: e,
                nextLv: () {
                  controller.nextLvForEnum(userSpaceEnum: e);
                },
                onSelected: (value){
                  switch(value){
                    case "create":
                      controller.createOrganization(userSpaceEnum: e);
                      break;
                    case "edit":
                      controller.editOrganization(userSpaceEnum: e);
                      break;
                  }
                },
              ))
              .toList(),
        );
      }
    });
  }

  @override
  RelationController getController() {
    return RelationController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}