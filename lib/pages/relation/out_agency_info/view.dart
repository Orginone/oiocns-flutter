import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/utils/date_utils.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class OutAgencyInfoPage
    extends BaseGetView<OutAgencyInfoController, OutAgencyInfoState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.group.metadata.name ?? "",
      body: SingleChildScrollView(
        child: Column(
          children: [
            info(),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonWidget.commonNonIndicatorTabBar(
                      state.tabController, tabTitle, onTap: (index) {
                    controller.changeView(index);
                  }),
                ),
                CommonWidget.commonPopupMenuButton(
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
                )
              ],
            ),
            body(),
          ],
        ),
      ),
    );
  }

  Widget info() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "集团信息",
            style: TextStyle(fontSize: 21.sp),
          ),
          CommonWidget.commonTextContentWidget(
              "集团名称", state.group.metadata.name!),
          CommonWidget.commonTextContentWidget(
              "集团代码", state.group.metadata.code!),
          CommonWidget.commonTextContentWidget(
              "团队简称", state.group.metadata.name!),
          CommonWidget.commonTextContentWidget(
              "团队标识", state.group.metadata.code!),
          CommonWidget.commonTextContentWidget("创建人", '',
              userId: state.group.metadata.createUser!),
          CommonWidget.commonTextContentWidget("创建时间",
              DateTime.tryParse(state.group.metadata.createTime!)!.format()),
          CommonWidget.commonTextContentWidget(
              "简介", state.group.metadata.remark ?? ""),
        ],
      ),
    );
  }

  Widget body() {
    return Obx(() {
      List<List<String>> content = [];
      for (var user in state.unitMember) {
        content.add([
          user.name!,
          user.code!,
          user.name ?? "",
          user.code ?? "",
          user.remark ?? ""
        ]);
      }
      return CommonWidget.commonDocumentWidget(
          title: outGroupTitle,
          content: content,
          showOperation: true,
          popupMenus: [
            const PopupMenuItem(value: 'out', child: Text("移除单位")),
          ],
          onOperation: (type, data) {
            controller.removeMember(data);
          });
    });
  }
}
