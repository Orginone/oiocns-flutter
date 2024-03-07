import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart' as model;
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/utils/toast_utils.dart';

class ScanLoginPage extends BeautifulBGStatelessWidget {
  late String connectionId;
  late Map<String, dynamic>? scanData;

  ///"{"location":"asset","platName":"资产共享云","connectionId":"0ygWmXjn6taaaHCRCcQMZg=="}"
  ScanLoginPage({super.key}) {
    dynamic param = Get.arguments;
    if (StringUtil.isJson(param)) {
      scanData = jsonDecode(param);
      connectionId = scanData?["connectionId"];
    } else {
      connectionId = param;
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return topAndBottomLayout(top: _top(context), bottom: _bottom());
  }

  Widget _top(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: (MediaQuery.maybeOf(context)?.size.height ?? 600) / 4,
      ),
      XImage.localImage(XImage.scanLogin, width: 180),
      Text(
        "登录${scanData?['platName'] ?? '奥集能'}PC端",
        style: TextStyle(
            color: XColors.black,
            fontSize: 20.sp,
            decoration: TextDecoration.none),
      ),
    ]);
  }

  Widget _bottom() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                login();
              },
              child: Container(
                width: double.infinity,
                height: 60.h,
                decoration: BoxDecoration(
                  color: XColors.themeColor,
                  borderRadius: BorderRadius.circular(10.w),
                ),
                alignment: Alignment.center,
                child: Text(
                  "确定登录",
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
    model.ResultType res = await relationCtrl.provider.qrAuth(connectionId);
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
