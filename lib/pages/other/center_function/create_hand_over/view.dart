import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/mapping_components.dart';

import '../../add_asset/item.dart';
import 'logic.dart';
import 'state.dart';


class CreateHandOverPage
    extends BaseGetView<CreateHandOverController, CreateHandOverState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "${state.isEdit ? "提交" : "创建"}交回",
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  basicInfo(),
                  transferInfo(),
                  CommonWidget.commonAddDetailedWidget(
                      text: "选择资产",
                      onTap: () {
                        controller.jumpAddAsset();
                      })
                ],
              ),
            ),
          ),
          CommonWidget.commonCreateSubmitWidget(submit: (){
            controller.submit();
          },draft: (){
            controller.draft();
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
          CommonWidget.commonHeadInfoWidget(state.config.config![0].title??""),
          ...state.config.config![0].fields!.map((e){
            Widget child = testMappingComponents[e.type??""]!(e,isEdit: state.isEdit,assetsType: AssetsType.handOver);
            return child;
          }),
        ],
      ),
    );
  }

  Widget transferInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget("交回明细",
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

