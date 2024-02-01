import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/values/images.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';

import 'logic.dart';
import 'state.dart';

class LoginPage extends BaseGetView<LoginController, LoginState> {
  const LoginPage({super.key});

  @override
  Widget buildView() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              CommonWidget.imageBackground(),
              CommonWidget.logoLR(),
              switchLoginType(),
              loginForm(),
              // loginSubmit(),
              // thirdLoginPlatform(),
            ],
          ),
        ),
      ),
    );
  }

  //切换账号登录和验证码登录类型
  Widget switchLoginType() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.29,
      left: 35,
      right: 35,
      child: Obx(() {
        return SizedBox(
          width: 375,
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              switchTips(state.accountLogin, '账号登录', 1),
              switchTips(state.phoneNumberLogin, '短信登录', 0),
            ],
          ),
        );
      }),
    );
  }

  Widget switchTips(RxBool isChoice, String title, int x) {
    if (isChoice.isTrue) {
      return GestureDetector(
        onTap: () {
          controller.switchMode(x);
        },
        child: Container(
          width: 88,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF366EF4),
                  fontSize: 14,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                width: 16,
                height: 3,
                decoration: ShapeDecoration(
                  color: const Color(0xFF366EF4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          controller.switchMode(x);
        },
        child: Container(
          width: 88,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF15181D),
                  fontSize: 14,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }
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
                style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
              ),
            )),
            const TextSpan(text: "与"),
            WidgetSpan(
                child: GestureDetector(
              child: Text(
                "《隐私条款》",
                style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
              ),
            ))
          ]),
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        )
      ],
    );
  }

  //登录提交按钮
  Widget loginSubmit() {
    return SizedBox(
      height: 45,
      child: GestureDetector(
        onTap: () {
          if (controller.state.accountLogin.value) {
            controller.login();
          }
          if (controller.state.phoneNumberLogin.value) {
            controller.verifyCodeLogin();
          }
        },
        child: button(XColors.themeColor),
      ),
    );
  }

  Widget button(Color color) {
    double widthBtn = MediaQuery.of(context).size.width - 70;
    return Container(
        width: widthBtn,
        height: 45,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 12),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE7E8EB)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '登录',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w600,
            height: 0.09,
          ),
        ));
  }

  //第三方登录按钮
  Widget thirdLoginPlatform() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '其他方式',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6000000238418579),
              fontSize: 14,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 16),
          plantForm(AssetsImages.loginWechat),
          const SizedBox(width: 16),
          plantForm(AssetsImages.loginZhifubao),
          const SizedBox(width: 16),
          plantForm(AssetsImages.loginDing),
        ],
      ),
    );
  }

  Widget plantForm(
    String icon,
  ) {
    return Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDCDCDC)),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(icon),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //登录账号密码验证码表单
  Widget loginForm() {
    return Obx(() {
      if (state.accountLogin.value) {
        return Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: 35,
            right: 35,
            height: 500,
            child: SizedBox(
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonWidget.commonIconInput(
                        onChanged: (value) {
                          controller.allowLogin();
                        },
                        controller: state.accountController,
                        icon: AssetsImages.loginAccount,
                        hint: '请输入账号',
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ]),
                    const SizedBox(height: 10),
                    CommonWidget.commonIconInputAction(
                        onChanged: (value) {
                          controller.allowLogin();
                        },
                        controller: state.passWordController,
                        icon: AssetsImages.loginSecret,
                        hint: '请输入密码',
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                        obscureText: state.passwordUnVisible.value,
                        action: IconButton(
                            padding: const EdgeInsets.only(left: 10),
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
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              child: GestureDetector(
                            onTap: () {
                              controller.register();
                            },
                            child: const Text(
                              "注册用户",
                              style: TextStyle(color: XColors.themeColor),
                            ),
                          )),
                          Container(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () {
                                controller.forgotPassword(
                                    state.accountController.text);
                              },
                              child: const Text(
                                "忘记密码",
                                style: TextStyle(color: XColors.themeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    loginSubmit(),
                    const SizedBox(height: 20),
                    thirdLoginPlatform(),
                  ],
                )));
      } else {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.38,
          left: 35,
          right: 35,
          height: 400,
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonWidget.commonIconInput(
                  onChanged: (value) {
                    controller.allowLogin();
                  },
                  controller: state.phoneNumberController,
                  icon: AssetsImages.loginAccount,
                  hint: '请输入手机号',
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                ),
                const SizedBox(height: 10),
                CommonWidget.commonIconInputVerifyCode(
                  onChanged: (value) {
                    controller.allowLogin();
                  },
                  controller: state.verifyController,
                  icon: AssetsImages.loginSecret,
                  hint: '请输入验证码',
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  action: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: verificationCodeCountDown(),
                  ),
                ),
                const SizedBox(height: 60),
                loginSubmit(),
                const SizedBox(height: 20),
                thirdLoginPlatform(),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget verificationCodeCountDown() {
    return Obx(() {
      TextStyle textStyle =
          TextStyle(color: XColors.themeColor, fontSize: 20.sp);
      String text = '发送验证码';
      if (state.startCountDown.value) {
        textStyle = TextStyle(color: Colors.grey, fontSize: 18.sp);
        text = "${state.countDown.value}秒后重新发送";
      }
      return GestureDetector(
          onTap: () {
            if (!state.sendVerify.value) {
              controller.sendLoginVerify();
            }
          },
          child: Text(
            text,
            textAlign: TextAlign.end,
            style: textStyle,
          ));
    });
  }
}
