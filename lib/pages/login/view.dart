import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class LoginPage extends BaseGetView<LoginController, LoginState> {
  @override
  Widget buildView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tips(),
            SizedBox(
              height: 75.h,
            ),
            loginBox(),
            SizedBox(
              height: 10.h,
            ),
            switchMode(),
            SizedBox(
              height: 100.h,
            ),
            clause(),
            SizedBox(
              height: 15.h,
            ),
            loginButton(),
          ],
        ),
      ),
    );
  }

  Widget tips() {
    return Obx(() {
      String loginType = '';
      String tip = '';
      if (state.accountLogin.value) {
        loginType = "账号密码登录";
        tip = '请输入用户名和密码';
      }
      if (state.phoneNumberLogin.value) {
        loginType = "手机号码登录";
        tip = '未注册的手机号登录成功后将自动注册';
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loginType,
            style: TextStyle(fontSize: 40.sp),
          ),
          Text(
            tip,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      );
    });
  }

  Widget loginBox() {
    return Obx(() {
      if (state.phoneNumberLogin.value) {
        return CommonWidget.commonTextField(
            controller: state.phoneNumberController,
            hint: '请输入手机号',
            title: "手机号",
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ]);
      }
      return Column(
        children: [
          CommonWidget.commonTextField(
              controller: state.accountController,
              hint: '请输入用户名或手机号码',
              title: "用户名"),
          CommonWidget.commonTextField(
              controller: state.passWordController,
              hint: '请输入密码',
              title: '密码',
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
                  ))),
        ],
      );
    });
  }

  Widget switchMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          return GestureDetector(
            onTap: () {
              controller.switchMode();
            },
            child: Text.rich(
              TextSpan(children: [
                const WidgetSpan(
                    child: Icon(Icons.swap_horiz, color: XColors.themeColor),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(
                    text: state.accountLogin.value
                        ? "手机号登录"
                        : state.phoneNumberLogin.value
                        ? "账号密码登录"
                        : ""),
              ]),
              style: const TextStyle(color: XColors.themeColor),
            ),
          );
        }),
        Obx(() {
          if(state.phoneNumberLogin.value){
            return Container();
          }
          return GestureDetector(
            onTap: () {
              controller.forgotPassword();
            },
            child: const Text(
              "忘记密码",
              style: TextStyle(color: XColors.themeColor),
            ),
          );
        }),
      ],
    );
  }

  Widget clause() {
    return Row(
      children: [
        Obx(() {
          return CommonWidget.commonMultipleChoiceButtonWidget(
              isSelected: state.agreeTerms.value,
              iconSize: 24.w,
              changed: (v) {
                controller.changeAgreeTerms();
              });
        }),
        SizedBox(
          width: 10.w,
        ),
        Text.rich(
          TextSpan(children: [
            const TextSpan(text: "同意"),
            WidgetSpan(
                child: GestureDetector(
                  child: Text(
                    "《服务条款》",
                    style: TextStyle(
                        color: XColors.themeColor, fontSize: 20.sp),
                  ),
                )),
            const TextSpan(text: "与"),
            WidgetSpan(
                child: GestureDetector(
                  child: Text(
                    "《隐私条款》",
                    style: TextStyle(
                        color: XColors.themeColor, fontSize: 20.sp),
                  ),
                ))
          ]),
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        )
      ],
    );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: () {
        if (state.accountLogin.value) {
          controller.login();
        }
        if (state.phoneNumberLogin.value) {
          controller.sendVerify();
        }
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
            child: Obx(() {
              String text = '';
              if (state.accountLogin.value) {
                text = "登录";
              }
              if (state.phoneNumberLogin.value) {
                text = "发送验证码";
              }
              return Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              );
            }),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller.register();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
              child: Text(
                "注册用户",
                style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
              ),
            ),
          )
        ],
      ),
    );
  }
}
