import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/cofig.dart';
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
                  controller.nextLvForEnum(e);
                },
              ))
              .toList(),
        );
      }else{
        return Container();
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