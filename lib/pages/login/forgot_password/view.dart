import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/values/constants.dart';
import 'package:orginone/utils/storage.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'logic.dart';
import 'state.dart';

class ForgotPasswordPage
    extends BaseGetView<ForgotPasswordController, ForgotPasswordState> {
  const ForgotPasswordPage({super.key});

  @override
  Widget buildView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildModifyPasswordWidget(),
              ),
            ),
            const BackButton(color: Colors.black),
          ],
        ),
      ),
    );
  }

  // 构建修改密码页面
  // 分两种场景 1：忘记密码（未登录） 2：修改密码（已登录）
  List<Widget> buildModifyPasswordWidget() {
    var account = Storage.getList(Constants.account);
    List<Widget> widgets = [];
    String title = '忘记密码';
    title = '修改密码';

    widgets = [
      Text(
        title,
        style: TextStyle(fontSize: 40.sp),
      ),
      SizedBox(
        height: 75.h,
      )
    ];
    if (account != null) {
      state.accountController.text = account[0];
    } else {
      widgets.add(CommonWidget.commonTextField(
          controller: state.accountController, hint: "请输入用户名", title: "用户名"));
    }

    widgets.addAll([
      CommonWidget.commonTextField(
          controller: state.keyController, hint: "请输入注册时保存的账户私钥", title: "私钥"),
      Obx(() {
        return CommonWidget.commonTextField(
            controller: state.passWordController,
            hint: "请输入密码",
            title: "密码",
            obscureText: state.passwordUnVisible.value,
            action: IconButton(
                onPressed: () {
                  controller.showPassWord();
                },
                icon: Icon(
                  state.passwordUnVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 24.w,
                  color: Colors.grey,
                )));
      }),
      Obx(() {
        return CommonWidget.commonTextField(
            controller: state.verifyPassWordController,
            hint: "请再次输入密码",
            title: "确认密码",
            obscureText: state.verifyPassWordUnVisible.value,
            action: IconButton(
                onPressed: () {
                  controller.showVerifyPassWord();
                },
                icon: Icon(
                  state.verifyPassWordUnVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 24.w,
                  color: Colors.grey,
                )));
      }),
      SizedBox(
        height: 25.h,
      ),
      submitButton()
    ]);

    return widgets;
  }

  Widget submitButton() {
    return GestureDetector(
      onTap: () {
        controller.submit();
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              color: XColors.themeColor,
              borderRadius: BorderRadius.circular(40.w),
            ),
            alignment: Alignment.center,
            child: Text(
              "提交",
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
