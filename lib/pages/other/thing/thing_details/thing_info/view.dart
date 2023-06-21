import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class ThingInfoPage
    extends BaseGetPageView<ThingInfoController, ThingInfoState> {
  @override
  Widget buildView() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(children: [
          CommonWidget.commonHeadInfoWidget(
             state.form.metadata.name!),
          CommonWidget.commonFormWidget(
              formItem: state.attr.map((e) {
            String value = e.value ?? "";
            return CommonWidget.commonFormItem(
                title: e.name ?? "",
                content: value,
                userId: e.valueType == "用户型" ? e.value ?? "" : '');
          }).toList())
        ]);
      }),
    );
  }

  @override
  ThingInfoController getController() {
    return ThingInfoController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "ThingInfo";
  }
}
