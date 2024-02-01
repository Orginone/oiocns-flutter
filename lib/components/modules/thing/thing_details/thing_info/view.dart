import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';

import 'logic.dart';
import 'state.dart';

class ThingInfoPage
    extends BaseGetPageView<ThingInfoController, ThingInfoState> {
  ThingInfoPage({super.key});

  @override
  Widget buildView() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(children: [
          CommonWidget.commonHeadInfoWidget(state.form.metadata.name!),
          CommonWidget.commonFormWidget(
              formItem: state.attr.map((e) {
            String value = e.property?.valueType ?? "";
            return CommonWidget.commonFormItem(
                title: e.name ?? "",
                content: value,
                userId: e.value ??
                    ""); //e.valueType == "用户型" ? e.value ?? "" : '');
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
