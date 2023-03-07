import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import '../../add_asset/item.dart';
import 'logic.dart';
import 'state.dart';

class CreateDisposePage
    extends BaseGetView<CreateDisposeController, CreateDisposeState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "${state.isEdit ? "提交" : "创建"}处置",
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                basicInfo(),
                disposeInfo(),
                CommonWidget.commonAddDetailedWidget(
                    text: "选择资产",
                    onTap: () {
                      controller.jumpAddAsset();
                    })
              ],
            ),
          )),
          CommonWidget.commonCreateSubmitWidget(draft: () {
            controller.draft();
          }, submit: () {
            controller.submit();
          }),
        ],
      ),
    );
  }

  Widget basicInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget("基本信息"),
          Obx(() {
            return CommonWidget.commonChoiceTile(
                "处置方法", state.disposeType.value,
                showLine: true, onTap: () {
              controller.showProcessingMethod();
            }, required: true);
          }),
          Obx(() {
            return CommonWidget.commonChoiceTile(
                "资产接受单位类型", state.unitType.value,
                showLine: true, onTap: () {
              controller.showUnit();
            });
          }),
          CommonWidget.commonTextTile(
            "资产接受单位名称",
            "",
            hint: "请填写资产接受单位名称",
            controller: state.unitController,
          ),
          CommonWidget.commonTextTile(
            "资产接受单位电话",
            "",
            hint: "请填写资产接受单位电话",
            controller: state.phoneNumberController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          Obx(() {
            return CommonWidget.commonChoiceTile(
                "是否评估", state.assessment.value,
                showLine: true, onTap: () {
              controller.showAssessment();
            });
          }),
          SizedBox(
            height: 10.h,
          ),
          CommonWidget.commonTextTile("申请原因", "",
              hint: "请填写申请事由",
              maxLine: 4,
              controller: state.reasonController,
              required: true),
        ],
      ),
    );
  }

  Widget disposeInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget("处置明细",
              action: GestureDetector(
                child: const Text(
                  "批量删除",
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  controller.jumpBulkRemovalAsset();
                },
              )),
          Obx(() {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Item(
                  assets: state.selectAssetList[index],
                  openInfo: () {
                    controller.openInfo(index);
                  },
                  supportSideslip: true,
                  delete: () {
                    controller.removeItem(index);
                  },
                );
              },
              itemCount: state.selectAssetList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            );
          })
        ],
      ),
    );
  }
}
