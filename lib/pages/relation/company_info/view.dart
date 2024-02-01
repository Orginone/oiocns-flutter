import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/pages/relation/widgets/document.dart';

import 'logic.dart';
import 'state.dart';

class CompanyInfoPage
    extends BaseGetView<CompanyInfoController, CompanyInfoState> {
  const CompanyInfoPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "公司信息",
      body: SingleChildScrollView(
        child: Column(
          children: [
            companyInfo(),
            SizedBox(
              height: 10.h,
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: CommonWidget.commonNonIndicatorTabBar(
                        state.tabController, companyTabTitle, onTap: (index) {
                      controller.changeView(index);
                    }),
                  ),
                  CommonWidget.commonPopupMenuButton(
                      items: const [
                        PopupMenuItem(
                          value: CompanyFunction.roleSettings,
                          child: Text("角色设置"),
                        ),
                      ],
                      onSelected: (CompanyFunction function) {
                        controller.companyOperation(function);
                      },
                      color: Colors.transparent),
                ],
              ),
            ),
            body(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Obx(() {
      if (state.index.value == 1) {
        List<List<String>> groupContent = [];
        for (var group in state.joinGroup) {
          groupContent.add([
            group.metadata.name!,
            group.metadata.code!,
            group.metadata.remark ?? ""
          ]);
        }
        return CommonWidget.commonDocumentWidget(
          title: groupTitle,
          content: groupContent,
        );
      }
      return UserDocument(
        popupMenus: const [
          PopupMenuItem(value: 'out', child: Text("踢出")),
        ],
        onOperation: (type, data) {
          controller.removeMember(data);
        },
        unitMember: state.unitMember.value,
      );
    });
  }

  Widget companyInfo() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "当前单位",
            style: TextStyle(fontSize: 21.sp),
          ),
          CommonWidget.commonTextContentWidget(
              "单位名称", state.company.metadata.name!),
          CommonWidget.commonTextContentWidget(
              "社会统一信用代码", state.company.metadata.code!),
          CommonWidget.commonTextContentWidget(
              "单位简介", state.company.metadata.remark ?? "",
              maxLines: 3),
        ],
      ),
    );
  }
}
