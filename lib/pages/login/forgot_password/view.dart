import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
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
    //             children: buildModifyPasswordWidget(),
    //           ),
    //         ),
    //         const BackButton(color: Colors.black),
    //       ],
    //     ),
    //   ),
    // );
    return Material(
      child: GestureDetector(
        //向右滑动累计大于100像素表示为返回
        onHorizontalDragUpdate: (details) {
          state.distance += details.delta.dx;
          if (state.distance > 100) {
            controller.backToLoginPage();
          }
        },
        child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                CommonWidget.imageBackground(),
                backToLogin(),
                CommonWidget.logo(),
                Positioned(
                  top: 300,
                  left: 36,
                  right: 35,
                  child: Text(
                    '忘记密码',
                    style: TextStyle(fontSize: 40.sp),
                  ),
                ),
                verifyForm(),
              ],
            )),
      ),
    );
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

  Widget verifyForm() {
    return Positioned(
        top: 400,
        left: 36,
        right: 36,
        child: Obx(() {
          return Column(
            children: [
              CommonWidget.commonTextInputAction(
                controller: state.keyController,
                title: '私钥',
                hint: '请输入注册时保存的账户私钥',
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
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
              const SizedBox(height: 20),
              comfirmSubmit(),
              // ElevatedButton(
              //   onPressed: () {
              //     if (state.passWordController.text.isNotEmpty &&
              //         state.verifyPassWordController.text.isNotEmpty) {
              //       controller.submit();
              //     }
              //   },
              //   // 根据输入框的值是否为空动态更改按钮颜色
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.resolveWith<Color>(
              //       (Set<MaterialState> states) {
              //         return state.passWordController.text.isNotEmpty &&
              //                 state.verifyPassWordController.text.isNotEmpty &&
              //                 state.keyController.text.isNotEmpty
              //             ? XColors.themeColor
              //             : const Color(0xFFB5C7FF);
              //       },
              //     ),
              //   ),
              //   child: const Text('确认'),
              // ),
            ],
          );
        }));
  }

  // 构建修改密码页面
  // 分两种场景 1：忘记密码（未登录） 2：修改密码（已登录）
  List<Widget> buildModifyPasswordWidget() {
    var account = Storage.getList(Constants.account);
    List<Widget> widgets = [];
    String title = '忘记密码';
    title = '修改密码';

    widgets = [
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

  //登录提交按钮
  Widget comfirmSubmit() {
    return GestureDetector(
      onTap: () {
        controller.submit();
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
              '确认修改',
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
}
