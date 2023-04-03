import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/setting/cofig.dart';
import 'package:orginone/widget/common_widget.dart';
import '../item.dart';
import 'logic.dart';
import 'state.dart';


class StandardPage extends BaseGetPageView<StandardController,StandardState>{
  @override
  Widget buildView() {
    return Column(
      children: [
        CommonWidget.commonBreadcrumbNavWidget(
          firstTitle: "标准",
          allTitle: [],
        ),
        Expanded(child: Column(
          children: StandardEnum.values
              .map((e) =>
              Item(
                standardEnum: e,
                nextLv: () {
                  controller.nextLvForEnum(e);
                },
              ))
              .toList(),
        ))
      ],
    );
  }

  @override
  StandardController getController() {
   return StandardController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}
