import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/widget.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class UserInfoPage extends BaseGetView<UserInfoController, UserInfoState> {
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
                        state.tabController, tabTitle, onTap: (index) {
                      controller.changeView(index);
                    }),
                  ),
                  CommonWidget.commonPopupMenuButton(
                      items: const [
                        PopupMenuItem(
                          value: UserFunction.record,
                          child: Text("查看申请记录"),
                        ),
                        PopupMenuItem(
                          value: UserFunction.addUser,
                          child: Text("添加好友"),
                        ),
                        PopupMenuItem(
                          value: UserFunction.addGroup,
                          child: Text("加入单位"),
                        ),
                      ],
                      onSelected: (UserFunction function) {
                        controller.userOperation(function);
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
        List<List<String>> companyContent = [];
        for (var company in state.joinCompany) {
          companyContent.add([
            company.name,
            company.target.code,
            company.target.team?.name ?? "",
            company.target.team?.code ?? "",
            company.target.team?.remark ?? ""
          ]);
        }
        return CommonWidget.commonDocumentWidget(
            title: spaceTitle,
            content: companyContent,
            popupMenus: const [
              PopupMenuItem(value: 'out', child: Text("退出")),
            ],
            showOperation: true,
            onOperation: (type, data) {
              controller.removeCompany(data);
            });
      }
      return UserDocument(
        popupMenus: const [
          PopupMenuItem(value: 'out', child: Text("移除")),
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
            "个人信息",
            style: TextStyle(fontSize: 21.sp),
          ),
          CommonWidget.commonTextContentWidget(
              "昵称", state.user?.target.name ?? ""),
          CommonWidget.commonTextContentWidget(
              "姓名", state.user?.target.team?.name ?? ""),
          CommonWidget.commonTextContentWidget(
              "账号", state.user?.target.code ?? ""),
          CommonWidget.commonTextContentWidget(
              "联系方式", state.user?.target.team?.code ?? ""),
          CommonWidget.commonTextContentWidget(
              "座右铭", state.user?.target.team?.remark ?? ""),
        ],
      ),
    );
  }
}
