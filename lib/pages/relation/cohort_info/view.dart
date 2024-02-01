import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/utils/date_utils.dart';

import 'logic.dart';
import 'state.dart';

class CohortInfoPage
    extends BaseGetView<CohortInfoController, CohortInfoState> {
  const CohortInfoPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.cohort.metadata.name ?? "",
      body: SingleChildScrollView(
        child: Column(
          children: [
            cohortInfo(),
            Column(
              children: [
                CommonWidget.commonHeadInfoWidget(
                  "群组人员",
                  action: CommonWidget.commonPopupMenuButton(
                      items: const [
                        PopupMenuItem(
                          value: CompanyFunction.roleSettings,
                          child: Text("角色设置"),
                        ),
                        PopupMenuItem(
                          value: CompanyFunction.addUser,
                          child: Text("邀请成员"),
                        ),
                      ],
                      onSelected: (CompanyFunction function) {
                        controller.companyOperation(function);
                      },
                      color: Colors.transparent),
                ),
                Obx(() {
                  List<List<String>> memberContent = [];
                  for (var user in state.unitMember) {
                    memberContent.add([
                      user.code!,
                      user.name!,
                      user.name ?? "",
                      user.code ?? "",
                      user.remark ?? ""
                    ]);
                  }
                  return CommonWidget.commonDocumentWidget(
                      title: memberTitle,
                      content: memberContent,
                      showOperation: true,
                      popupMenus: [
                        const PopupMenuItem(value: 'out', child: Text("移除")),
                      ],
                      onOperation: (type, data) {
                        controller.removeMember(data);
                      });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cohortInfo() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "群组信息",
            style: TextStyle(fontSize: 21.sp),
          ),
          CommonWidget.commonTextContentWidget(
              "群组名称", state.cohort.metadata.name!),
          CommonWidget.commonTextContentWidget(
              "群组代码", state.cohort.metadata.code!),
          CommonWidget.commonTextContentWidget(
              "团队简称", state.cohort.metadata.name!),
          CommonWidget.commonTextContentWidget(
              "团队标识", state.cohort.metadata.code!),
          CommonWidget.commonTextContentWidget("创建人", "",
              userId: state.cohort.metadata.createUser!),
          CommonWidget.commonTextContentWidget("创建时间",
              DateTime.tryParse(state.cohort.metadata.createTime!)!.format()),
          CommonWidget.commonTextContentWidget(
              "简介", state.cohort.metadata.remark ?? ""),
        ],
      ),
    );
  }
}
