import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';

import '../add_asset/item.dart';
import 'logic.dart';
import 'state.dart';

class BulkRemovalAssetPage
    extends BaseGetView<BulkRemovalAssetController, BulkRemovalAssetState> {
  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("批量删除资产"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: XColors.themeColor,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            CommonWidget.commonHeadInfoWidget(state.info),
            allSelectButton(),
            Expanded(
              child: list(),
            ),
            CommonWidget.commonDeleteWidget(delete: (){
              controller.delete();
            })
          ],
        ),
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
        ));
  }
}
