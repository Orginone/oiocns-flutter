import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/shine_widget.dart';

import 'logic.dart';
import 'state.dart';

class CreateClaimPage
    extends BaseGetView<CreateClaimController, CreateClaimState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "${state.isEdit ? "提交" : "创建"}申领",
      body: Column(
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
          CommonWidget.commonHeadInfoWidget(state.config.config![0].title??""),
          ...state.config.config![0].fields!.map((e){
             Widget child = testShine[e.type??""]!(e,isEdit: state.isEdit,assetsType: AssetsType.claim);
             return child;
          }),
        ],
      ),
    );
  }

  Widget detailed(int index) {
    Config config =  state.detailedData[index];
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget(
            "${config.title}-${index + 1}",
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
          ...config.fields!.map((e){
            Widget child = testShine[e.type??""]!(e,isEdit: state.isEdit,assetsType: AssetsType.claim);
            return child;
          }).toList(),
        ],
      ),
    );
  }
}
