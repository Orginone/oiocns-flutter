import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/relation/widgets/document.dart';
import 'package:orginone/utils/load_image.dart';

import 'logic.dart';
import 'state.dart';

class UserInfoPage extends BaseGetView<UserInfoController, UserInfoState> {
  const UserInfoPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      // titleName: "个人信息",
      leadingWidth: 35,
      titleSpacing: 0,
      titleWidget: _titleWidget(),
      // operations: _operation(),
      centerTitle: false,
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

  List<Widget> _operation() {
    return [
      GestureDetector(
        onTap: () {
          showCupertinoDialog(
              context: Get.context!, builder: _buildConfirmDialog);
        },
        child: Text(
          "注销账户",
          style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
        ),
      )
    ];
  }

  Widget _buildConfirmDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("确认注销账户？"),
      content: const Text(
          // "进行自我删除用户（注销用户）操作，请点击确定前往https://asset.orginone.cn进行注销操作。"
          "您正在进行高危操作: 账号注销（删除用户）;账号注销后,所有信息将会销毁且无法再找回数据;\r\n\r\n请谨慎操作！！！"),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('取消'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('确定注销'),
          onPressed: () async {
            relationCtrl.user?.delete(notity: true);
            relationCtrl.exitLogin();
            // Navigator.pop(context);
            // String url = "https://asset.orginone.cn";
            // final uri = Uri.parse(url);
            // if (await canLaunchUrl(uri)) {
            //   await launchUrl(uri, mode: LaunchMode.externalApplication);
            // }
            // RoutePages.jumpWeb(url: "https://asset.orginone.cn");
          },
        ),
      ],
    );
  }

  Widget _titleWidget() {
    String name = state.user?.metadata.name ?? "";
    return name.isNotEmpty
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: XImage.entityIcon(state.user, width: 40.w),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      style: XFonts.size26Black3.merge(
                          const TextStyle(overflow: TextOverflow.ellipsis))),
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 2),
                  //     child: Text(spaceName, style: XFonts.size16Black9)),
                ],
              )
            ],
          )
        : Container();
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
