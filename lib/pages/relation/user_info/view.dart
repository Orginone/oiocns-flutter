import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/pages/relation/widgets/document.dart';

import 'logic.dart';
import 'state.dart';

class UserInfoPage extends BaseGetView<UserInfoController, UserInfoState> {
  const UserInfoPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "个人信息",
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
                        state.tabController, userTabTitle, onTap: (index) {
                      controller.changeView(index);
                    }),
                  ),
                  CommonWidget.commonPopupMenuButton(
                      items: const [
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
            company.metadata.name!,
            company.metadata.code!,
            company.metadata.name!,
            company.metadata.code!,
            company.metadata.remark ?? ""
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
              "昵称", state.user?.metadata.name ?? ""),
          CommonWidget.commonTextContentWidget(
              "姓名", state.user?.metadata.name ?? ""),
          CommonWidget.commonTextContentWidget(
              "账号", state.user?.metadata.code ?? ""),
          CommonWidget.commonTextContentWidget(
              "联系方式", state.user?.metadata.code ?? ""),
          CommonWidget.commonTextContentWidget(
              "座右铭", state.user?.metadata.remark ?? "",
              maxLines: 3),
        ],
      ),
    );
  }
}
