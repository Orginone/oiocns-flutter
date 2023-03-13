import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/center_function/create_transfer/state.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import '../../add_asset/item.dart';
import 'logic.dart';

class CreateTransferPage
    extends BaseGetView<CreateTransferController, CreateTransferState> {


  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "${state.isEdit ? "提交" : "创建"}移交",
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
          CommonWidget.commonCreateSubmitWidget(draft: (){
            controller.draft();
          },submit: (){
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
            return CommonWidget.commonTextTile(
              "单据编号",
              state.orderNum.value,
              enabled: false,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500),
            );
          }),
          SizedBox(
            height: 10.h,
          ),
          CommonWidget.commonTextTile("移交人与部门", "${HiveUtils
              .getUser()
              ?.userName??""}-${DepartmentManagement().currentDepartment?.name??""}",enabled: false, showLine: true),
          Obx(() {
            return CommonWidget.commonChoiceTile(
                "移交至人员", state.selectedUser.value?.name ?? "",
                showLine: true, onTap: () {
              controller.choicePeople();
            });
          }),
          Obx(() {
            return CommonWidget.commonChoiceTile(
                "移交至部门", state.selectedDepartment.value?.name ?? "",
                showLine: true, onTap: () {
              controller.choiceDepartment();
            });
          }),
          CommonWidget.commonTextTile("移交原因", "",
              hint: "请填写移交原因",
              maxLine: 4,
              controller: state.reasonController,
            required: true
            ),
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
          CommonWidget.commonHeadInfoWidget("移交明细",
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
