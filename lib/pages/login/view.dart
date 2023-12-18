import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class LoginPage extends BaseGetView<LoginController, LoginState> {
  const LoginPage({super.key});

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
          )),
    );
    // return Material(
    //   child: Container(
    //       clipBehavior: Clip.antiAlias,
    //       decoration: const BoxDecoration(color: Colors.white),
    //       child: Stack(
    //         children: [
    //           background(),
    //           logo(),
    //           switchLoginType(),
    //           loginForm(),
    //           loginSubmit(),
    //           thirdLoginPlatform(),
    //         ],
    //       )),
    // );
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
    return Obx(() {
      if (state.phoneNumberLogin.value) {
        return Container();
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
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
          ),
          GestureDetector(
            onTap: () {
              controller.forgotPassword();
            },
            child: const Text(
              "忘记密码",
              style: TextStyle(color: XColors.themeColor),
            ),
          )
        ],
      );
    });
  }

  // Widget switchLoginType() {
  //   return Positioned(
  //     top: 300,
  //     left: 20,
  //     child: GestureDetector(
  //         onTap: () {
  //           controller.switchMode();
  //         },
  //         child: SizedBox(
  //           width: 375,
  //           height: 50,
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               switchTips(state.accountLogin, '账号登录'),
  //               switchTips(state.phoneNumberLogin, '短信登录'),
  //             ],
  //           ),
  //         )),
  //   );
  // }

  // Widget switchTips(RxBool isChoice, String title) {
  //   if (isChoice.isTrue) {
  //     return Container(
  //       width: 88,
  //       height: 40,
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             title,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               color: Color(0xFF366EF4),
  //               fontSize: 14,
  //               fontFamily: 'PingFang SC',
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           Container(
  //             width: 16,
  //             height: 3,
  //             decoration: ShapeDecoration(
  //               color: const Color(0xFF366EF4),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(999),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       width: 88,
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             title,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               color: Color(0xFF15181D),
  //               fontSize: 14,
  //               fontFamily: 'PingFang SC',
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  Widget clause() {
    return Obx(() {
      return Row(
        children: [
          CommonWidget.commonMultipleChoiceButtonWidget(
              isSelected: state.agreeTerms.value,
              iconSize: 24.w,
              changed: (v) {
                controller.changeAgreeTerms();
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
    });
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

  // Widget loginSubmit() {
  //   return Positioned(
  //       top: 500,
  //       left: 35,
  //       child: GestureDetector(
  //           child: Container(
  //         width: 343,
  //         height: 48,
  //         padding: const EdgeInsets.only(top: 12),
  //         decoration: ShapeDecoration(
  //           color: const Color(0xFFB5C7FF),
  //           shape: RoundedRectangleBorder(
  //             side: const BorderSide(width: 1, color: Color(0xFFE7E8EB)),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //         ),
  //         child: const Row(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text(
  //                 '登录',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                   fontFamily: 'PingFang SC',
  //                   fontWeight: FontWeight.w600,
  //                   height: 0.09,
  //                 ),
  //               )
  //             ]),
  //       )));
  // }

  // Widget thirdLoginPlatform() {
  //   return Positioned(
  //     top: 580,
  //     left: 35,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text(
  //           '其他方式',
  //           style: TextStyle(
  //             color: Colors.black.withOpacity(0.6000000238418579),
  //             fontSize: 14,
  //             fontFamily: 'PingFang SC',
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         plantForm(AssetsImages.loginWechat),
  //         const SizedBox(width: 16),
  //         plantForm(AssetsImages.loginZhifubao),
  //         const SizedBox(width: 16),
  //         plantForm(AssetsImages.loginDing),
  //       ],
  //     ),
  //   );
  // }

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

  // //logo
  // Widget logo() {
  //   return Positioned(
  //     top: 100.00,
  //     left: 0,
  //     right: 0,
  //     child: Center(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
  //             width: 30,
  //             height: 30,
  //             clipBehavior: Clip.antiAlias,
  //             decoration: const BoxDecoration(
  //               image: DecorationImage(
  //                 image: AssetImage(AssetsImages.logoNoBg),
  //                 fit: BoxFit.fill,
  //               ),
  //             ),
  //           ),
  //           const Text.rich(TextSpan(
  //             text: '奥集能',
  //             style: TextStyle(
  //                 color: Color(0xFF15181D),
  //                 fontSize: 22.91,
  //                 fontFamily: 'PingFang SC',
  //                 fontWeight: FontWeight.w500,
  //                 decoration: TextDecoration.none),
  //           )),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget loginForm() {
  //   return Positioned(
  //     top: 370.00,
  //     left: 20,
  //     right: 20,
  //     child: SizedBox(
  //         height: 100,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             CommonWidget.commonLoginInput(
  //                 AssetsImages.loginAccount, '请输入账号', [
  //               FilteringTextInputFormatter.singleLineFormatter,
  //             ]),
  //             CommonWidget.commonLoginInput(AssetsImages.loginSecret, '请输入密码', [
  //               FilteringTextInputFormatter.singleLineFormatter,
  //             ]),
  //           ],
  //         )),
  //   );
  // }

  // Widget background() {
  //   return Container(
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           left: -200,
  //           child: Container(
  //             width: 900,
  //             height: 500,
  //             decoration: const BoxDecoration(
  //               image: DecorationImage(
  //                 image: AssetImage(AssetsImages.logoBackground),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           left: -200,
  //           child: Container(
  //             width: 900,
  //             height: 500,
  //             decoration: const BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [
  //                   Color.fromRGBO(249, 249, 249, 0),
  //                   Color.fromRGBO(255, 255, 255, 1),
  //                 ],
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
