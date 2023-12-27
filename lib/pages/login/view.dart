import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/values/images.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class LoginPage extends BaseGetView<LoginController, LoginState> {
  const LoginPage({super.key});

  @override
  Widget buildView() {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Padding(
    //     padding: EdgeInsets.symmetric(horizontal: 25.w),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         tips(),
    //         SizedBox(
    //           height: 75.h,
    //         ),
    //         loginBox(),
    //         SizedBox(
    //           height: 10.h,
    //         ),
    //         switchMode(),
    //         SizedBox(
    //           height: 100.h,
    //         ),
    //         clause(),
    //         SizedBox(
    //           height: 15.h,
    //         ),
    //         loginButton(),
    //       ],
    //     ),
    //   ),
    // );
    return Material(
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              CommonWidget.imageBackground(),
              CommonWidget.logo(),
              switchLoginType(),
              loginForm(),
              // loginSubmit(),
              // thirdLoginPlatform(),
            ],
          )),
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
              controller.switchMode(1);
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
          if (state.phoneNumberLogin.value) {
            return Container();
          }
          return GestureDetector(
            onTap: () {
              controller.forgotPassword(state.accountController.text);
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

  //切换账号登录和验证码登录类型
  Widget switchLoginType() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.33,
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
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
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

  //登录提交按钮
  Widget loginSubmit() {
    return Container(
      // top: MediaQuery.of(context).size.height * 0.69,
      // left: 35,
      // right: 35,
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
            top: MediaQuery.of(context).size.height * 0.42,
            left: 35,
            right: 35,
            child: SizedBox(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonWidget.commonIconInputAction(
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
                        padding: const EdgeInsets.only(left: 40),
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
                            controller
                                .forgotPassword(state.accountController.text);
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
          top: MediaQuery.of(context).size.height * 0.42,
          left: 35,
          right: 35,
          child: SizedBox(
            // height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonWidget.commonIconInputAction(
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
                CommonWidget.commonIconInputAction(
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
        textStyle = TextStyle(color: Colors.grey, fontSize: 16.sp);
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
