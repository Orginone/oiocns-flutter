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
        return Column(
            children: state.details.map((element) {
              return Column(
                children: [
                  CommonWidget.commonHeadInfoWidget(element.specie.metadata.name),
                  CommonWidget.commonFormWidget(
                      formItem: element.data.map((e) {
                        String value = e.value.toString();
                        if (e.xAttribute.valueType == "选择型") {
                          try {
                            value = e.xAttribute.dict?.dictItems
                                ?.firstWhere((element) =>
                            element.value == e.value)
                                .name ??
                                "";
                          } catch (e) {
                            value = "";
                          }
                        }

                        return CommonWidget.commonFormItem(
                            title: e.xAttribute.name ?? "", content: value);
                      }).toList())
                ],
              );
            }).toList());
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
