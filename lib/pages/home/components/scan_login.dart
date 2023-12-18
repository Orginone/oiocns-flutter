import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart' as model;
import 'package:orginone/main.dart';
import 'package:orginone/utils/toast_utils.dart';

class ScanLoginPage extends StatelessWidget {
  late String connectionId;
  ScanLoginPage({super.key}) {
    connectionId = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColors.bgColor,
      padding: EdgeInsets.all(30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.computer, size: 180, color: XColors.entryBgColor),
          const Text(
            "登录奥集能PC端",
            style: TextStyle(
                color: XColors.black666,
                fontSize: 34,
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 100.h,
          ),
          GestureDetector(
              onTap: () {
                login();
              },
              child: Container(
                width: double.infinity,
                height: 60.h,
                decoration: BoxDecoration(
                  color: XColors.themeColor,
                  borderRadius: BorderRadius.circular(40.w),
                ),
                alignment: Alignment.center,
                child: Text(
                  "登录",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      decoration: TextDecoration.none),
                ),
              )),
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              cancelLogin();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Text(
                "取消登录",
                style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> login() async {
    model.ResultType res = await settingCtrl.provider.qrAuth(connectionId);
    if (res.success) {
      ToastUtils.showMsg(msg: "登录成功");
      Get.back();
    } else {
      ToastUtils.showMsg(msg: "登录失败：${res.msg}");
    }
  }

  void cancelLogin() {
    Get.back();
  }
}
