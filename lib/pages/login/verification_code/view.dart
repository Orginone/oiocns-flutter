import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import 'logic.dart';
import 'state.dart';

class VerificationCodePage
    extends BaseGetView<VerificationCodeController, VerificationCodeState> {
  const VerificationCodePage({super.key});

  @override
  Widget buildView() {
    return Scaffold(
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
                  verificationCode(),
                  verificationCodeCountDown(),
                ],
              ),
            ),
            const BackButton(color: Colors.black)
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget tips() {
    String loginType = '输入验证码';
    String tip = '验证码会发送至  +86${state.phoneNumber}';
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
  }

  Widget verificationCode() {
    return Obx(() {
      Color pinColor = Colors.black;
      Widget statusWidget = Container();
      if (state.verificationDone.value) {
        if (state.hasError) {
          pinColor = Colors.red;
          statusWidget = error;
        } else {
          pinColor = Colors.green;
          statusWidget = success;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PinInputTextField(
            onChanged: (str) {
              controller.verification(str);
            },
            decoration: UnderlineDecoration(
                colorBuilder: PinListenColorBuilder(pinColor, Colors.black)),
          ),
          SizedBox(
            height: 10.h,
          ),
          statusWidget,
        ],
      );
    });
  }

  Widget verificationCodeCountDown() {
    return Obx(() {
      TextStyle textStyle =
          TextStyle(color: XColors.themeColor, fontSize: 16.sp);
      String text = '重新获取验证码';
      if (state.startCountDown.value) {
        textStyle = TextStyle(color: Colors.grey, fontSize: 16.sp);
        text = "${state.countDown.value}秒后重新获取";
      }
      return GestureDetector(
          onTap: () {
            if (!state.startCountDown.value) {
              controller.resend();
            }
          },
          child: Text(
            text,
            style: textStyle,
          ));
    });
  }

  Widget get error => Text.rich(
        TextSpan(children: [
          WidgetSpan(
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 24.w,
              ),
              alignment: PlaceholderAlignment.middle),
          const TextSpan(text: "请输入正确的验证码"),
        ]),
        style: TextStyle(color: Colors.red, fontSize: 20.sp),
      );

  Widget get success => Text.rich(
        TextSpan(children: [
          WidgetSpan(
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Icon(
                  Icons.done,
                  size: 20.w,
                  color: Colors.white,
                ),
              ),
              alignment: PlaceholderAlignment.middle),
          const TextSpan(text: "验证完成"),
        ]),
        style: TextStyle(color: Colors.green, fontSize: 20.sp),
      );
}
