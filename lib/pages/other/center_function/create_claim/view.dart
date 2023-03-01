import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class CreateClaimPage
    extends BaseGetView<CreateClaimController, CreateClaimState> {
  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: Text("${state.isEdit ? "提交" : "创建"}申领"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: XColors.themeColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    basicInfo(),
                    detailedList(),
                    CommonWidget.commonAddDetailedWidget(onTap: () {
                      controller.addDetailed();
                    }, text: '添加明细'),
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
      ),
    );
  }

  Widget detailedList() {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          return detailed(index);
        },
        itemCount: state.detailedData.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      );
    });
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
          CommonWidget.commonTextTile("申领事由", "",
              hint: "请填写申领事由", maxLine: 4, controller: state.reasonController,required: true),
        ],
      ),
    );
  }

  Widget detailed(int index) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget(
            "申领明细-${index + 1}",
            action: index > 0
                ? GestureDetector(
              child: Text(
                "删除",
                style: TextStyle(color: Colors.blue, fontSize: 16.sp),
              ),
              onTap: () {
                controller.deleteDetailed(index);
              },
            )
                : Container(),
          ),
          CommonWidget.commonChoiceTile(
              "资产分类", state.detailedData[index].assetType?.name??"",
              required: true, onTap: () {
            controller.choiceAssetClassification(index);
          }, showLine: true),
          CommonWidget.commonTextTile("资产名称", "",
              hint: "请填写资产名称",
              controller: state.detailedData[index].assetNameController,
              showLine: true,required: true),
          CommonWidget.commonTextTile(
              "领用人与部门", "${HiveUtils
              .getUser()
              ?.userName ?? ""}-${DepartmentManagement().currentDepartment?.name ??
              ""}", showLine: true, enabled: false),
          CommonWidget.commonTextTile("数量", "",
              hint: "请填写数量",
              controller: state.detailedData[index].quantityController,
              showLine: true,inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ]),
          CommonWidget.commonTextTile("规格型号", "",
              hint: "请填写规格型号",
              controller: state.detailedData[index].modelController,
              showLine: true),
          CommonWidget.commonTextTile("品牌", "",
              hint: "请填写品牌",
              controller: state.detailedData[index].brandController,
              showLine: true),
          // CommonWidget.commonChoiceTile("存放地点", state.detailedData[index].place,
          //     required: true, onTap: () {
          //       controller.choicePlace(index);
          //     }, showLine: true),
          CommonWidget.commonChoiceTile(
              "是否信创", state.detailedData[index].isDistribution ? "是" : "否",
              onTap: () {
            controller.newCreate(index);
          }, showLine: true),
        ],
      ),
    );
  }
}
