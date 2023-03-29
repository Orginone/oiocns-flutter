import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import '../add_asset/item.dart';
import 'logic.dart';
import 'state.dart';

class BatchOperationAssetPage extends BaseGetView<BatchOperationAssetController,
    BatchOperationAssetState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "数字云资产",
      body: Column(
        children: [
          CommonWidget.commonHeadInfoWidget("我的资产"),
          allSelectButton(),
          Expanded(
            child: list(),
          ),
          CommonWidget.commonMultipleSubmitWidget(
            str1: "处置",
            str2: "移交",
            onTap1: () {
              controller.jump(AssetsType.dispose);
            },
            onTap2: () {
              controller.jump(AssetsType.transfer);
            },
          )
        ],
      ),
    );
  }

  Widget list() {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          return Item(
            showChoiceButton: true,
            assets: state.selectAssetList[index],
            openInfo: () {
              controller.openItem(index);
            },
            changed: (select) {
              controller.selectItem(index, select);
            },
          );
        },
        itemCount: state.selectAssetList.length,
      );
    });
  }

  Widget allSelectButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            return CommonWidget.commonMultipleChoiceButtonWidget(
                changed: (value) {
                  controller.selectAll(value);
                },
                isSelected: state.selectAll.value);
          }),
          SizedBox(
            width: 10.w,
          ),
          Obx(() {
            return Text(
              "已选:${state.selectCount.value}",
              style: TextStyle(fontSize: 20.sp),
            );
          }),
        ],
      ),
    );
  }
}
