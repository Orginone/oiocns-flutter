import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class RegisterPage extends BaseGetView<RegisterController, RegisterState> {
  const RegisterPage({super.key});

  @override
  Widget buildView() {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: Stack(
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 25.w),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               tips(),
    //               SizedBox(
    //                 height: 50.h,
    //               ),
    //               Obx(() {
    //                 return registerWidget();
    //               }),
    //               SizedBox(
    //                 height: 60.h,
    //               ),
    //               clause(),
    //               SizedBox(
    //                 height: 15.h,
    //               ),
    //               loginButton(),
    //             ],
    //           ),
    //         ),
    //         const BackButton(color: Colors.black),
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
              backToLogin(),
              SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 150,
                      left: 35,
                      right: 35,
                      child: Text(
                        '欢迎使用奥集能',
                        style: TextStyle(fontSize: 40.sp),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 35,
                      right: 35,
                      child: Text(
                        '请完善个人信息',
                        style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                      ),
                    ),
                    registerForm(),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget tips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '欢迎使用奥集能',
          style: TextStyle(fontSize: 40.sp),
        ),
        Text(
          '请完善个人信息',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget stepOne() {
    return Obx(() {
      return Column(
        children: [
          CommonWidget.commonTextField(
              controller: state.userNameController,
              hint: "请输入用户名",
              title: "用户名"),
          CommonWidget.commonTextField(
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
                  ))),
          CommonWidget.commonTextField(
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
                  ))),
        ],
      );
    });
  }

  Widget registerWidget() {
    return Column(
      children: [
        CommonWidget.commonTextField(
            controller: state.phoneNumberController,
            hint: "请输入手机号",
            title: "手机号"),
        CommonWidget.commonTextField(
            controller: state.dynamicCodeController,
            hint: "请输入验证码",
            title: "验证码",
            action: CommonWidget.commonLimitedTimeButtonWidget(
                check: controller.checkPhoneNumber,
                click: controller.getDynamicCode)),
        // CommonWidget.commonTextField(
        //   controller: state.nickNameController,
        //   hint: "请输入昵称",
        //   title: "昵称",
        // ),
        CommonWidget.commonTextField(
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
                ))),
        CommonWidget.commonTextField(
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
                ))),
        CommonWidget.commonTextField(
          controller: state.userNameController,
          hint: "请输入真实姓名",
          title: "姓名",
        ),
        CommonWidget.commonTextField(
          controller: state.remarkController,
          hint: "请输入座右铭",
          title: "座右铭",
        ),
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
        controller.register();
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
                "注册",
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
        ],
      ),
    );
  }

  Widget registerForm() {
    return Positioned(
        top: 250,
        left: 36,
        right: 36,
        child: Obx(() {
          return Column(
            children: [
              CommonWidget.commonTextInputAction(
                controller: state.phoneNumberController,
                title: '手机号',
                hint: '请输入手机号',
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
              const SizedBox(height: 10),
              CommonWidget.commonTextInputAction(
                controller: state.dynamicCodeController,
                title: '验证码',
                hint: '请输入验证码',
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                action: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: verificationCodeCountDown(),
                ),
              ),
              const SizedBox(height: 10),
              CommonWidget.commonTextInputAction(
                controller: state.passWordController,
                title: '密码',
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
                    )),
              ),
              const SizedBox(height: 10),
              CommonWidget.commonTextInputAction(
                controller: state.verifyPassWordController,
                title: '确认密码',
                hint: '请再次输入密码',
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                obscureText: state.verifyPassWordUnVisible.value,
                action: IconButton(
                    padding: const EdgeInsets.only(left: 40),
                    onPressed: () {
                      controller.showVerifyPassWord();
                    },
                    icon: Icon(
                      state.verifyPassWordUnVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 24.w,
                      color: Colors.grey,
                    )),
              ),
              const SizedBox(height: 10),
              CommonWidget.commonTextInputAction(
                controller: state.realNameController,
                title: '姓名',
                hint: '请输入真实姓名',
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
              const SizedBox(height: 10),
              CommonWidget.commonTextInputAction(
                controller: state.remarkController,
                title: '座右铭',
                hint: '请输入座右铭',
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
              const SizedBox(height: 20),
              clause(),
              const SizedBox(height: 20),
              comfirmSubmit(),
            ],
          );
        }));
  }

  Widget comfirmSubmit() {
    return GestureDetector(
      onTap: () {
        controller.register();
      },
      child: Container(
          width: 343,
          height: 48,
          padding: const EdgeInsets.only(top: 12),
          decoration: ShapeDecoration(
            color: XColors.themeColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE7E8EB)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Center(
            child: Text(
              '注册',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w600,
                height: 0.09,
              ),
            ),
          )),
    );
  }

  Widget verificationCodeCountDown() {
    return Obx(() {
      TextStyle textStyle =
          TextStyle(color: XColors.themeColor, fontSize: 20.sp);
      String text = '发送验证码';
      if (state.startCountDown.value) {
        textStyle = TextStyle(color: Colors.grey, fontSize: 15.sp);
        text = "${state.countDown.value}秒后重新发送";
      }
      return GestureDetector(
          onTap: () {
            if (!state.sendVerify.value) {
              controller.getDynamicCode();
            }
          },
          child: Text(
            text,
            textAlign: TextAlign.end,
            style: textStyle,
          ));
    });
  }

  Widget backToLogin() {
    return Positioned(
        top: 60,
        left: 20,
        child: GestureDetector(
          onTap: (() {
            controller.backToLoginPage();
          }),
          child: XIcons.arrowBack32,
        ));
  }
}
