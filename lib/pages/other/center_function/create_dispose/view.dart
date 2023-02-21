import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import '../../add_asset/item.dart';
import 'logic.dart';
import 'state.dart';

class CreateDisposePage
    extends BaseGetView<CreateDisposeController, CreateDisposeState> {
  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: Text("${state.isEdit ? "提交" : "创建"}处置"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: XColors.themeColor,
      ),
      backgroundColor: Colors.grey.shade200,
      body: WillPopScope(

        onWillPop: () {
          return controller.back();
        },
        child: SafeArea(
          child: Column(
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
              CommonWidget.commonCreateSubmitWidget(draft: (){
                controller.draft();
              },submit: (){
                controller.submit();
              }),
            ],
          ),
        ),
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
                "处置方法", state.disposeTyep.value, showLine: true, onTap: () {
              controller.showProcessingMethod();
            }, required: true);
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
          CommonWidget.commonHeadInfoWidget("移交信息",
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
