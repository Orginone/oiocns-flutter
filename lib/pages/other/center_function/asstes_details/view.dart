import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class AssetsDetailsPage
    extends BaseGetView<AssetsDetailsController, AssetsDetailsState> {
  EdgeInsetsGeometry get defaultPadding =>
      EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w);

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "资产详情",
      body: Obx(() {
        if (state.config.value == null) {
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ...state.config.value!.list!.map((e) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(
                              color: Colors.grey.shade200, width: 0.5))
                      ),
                      margin: EdgeInsets.only(top: 10.h),
                      child: Container(
                        child: CommonWidget.commonHeadInfoWidget(
                            e.title ?? ""),
                        padding: defaultPadding, color: Colors.white,),
                    ),
                    ...e.fieldList!.map((e) {
                      return CommonWidget.commonTextContentWidget(
                          e.name ?? "",
                          "${state.assets.allJson?[e.code] ?? ""}",
                          textSize: 22,
                          contentSize: 22,
                          padding: defaultPadding, color: Colors.white);
                    }).toList()
                  ],
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
}