import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class RegisterPage extends BaseGetView<RegisterController, RegisterState> {
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
                children: [
                  tips(),
                  SizedBox(
                    height: 75.h,
                  ),
                  Obx(() {
                    if (!state.isStepOne.value) {
                      return stepTwo();
                    }
                    return stepOne();
                  }),
                  SizedBox(
                    height: 60.h,
                  ),
                  clause(),
                  SizedBox(
                    height: 15.h,
                  ),
                  loginButton(),
                ],
              ),
            ),
            const BackButton(color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget tips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '欢迎使用爱共享',
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

  Widget stepTwo() {
    return Column(
      children: [
        CommonWidget.commonTextField(
            controller: state.phoneNumberController,
            hint: "请输入电话号码",
            title: "手机号"),
        CommonWidget.commonTextField(
          controller: state.nickNameController,
          hint: "请输入昵称",
          title: "昵称",
        ),
        CommonWidget.commonTextField(
          controller: state.realNameController,
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
        if (state.isStepOne.value) {
          controller.nextStep();
        } else {
          controller.register();
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
              if (state.isStepOne.value) {
                text = "下一步";
              } else {
                text = "注册";
              }
              return Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              );
            }),
          ),
          SizedBox(
            height: 10.h,
          ),
          Obx(() {
            if (state.isStepOne.value) {
              return Container();
            }
            return GestureDetector(
              onTap: () {
                controller.previousStep();
              },
              child: Text(
                "上一步",
                style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
              ),
            );
          })
        ],
      ),
    );
  }
}
