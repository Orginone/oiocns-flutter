import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:ota_update/ota_update.dart';

class SysUtil {
  static Logger log = Logger("SysUtil");

  static void setStatusBarBright() {
    // 设置 Android 头部的导航栏透明
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
          statusBarColor: UnifiedColors.navigatorBgColor,
          statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  static void update(Function callback) {
    String url = "https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe";
    var stream = OtaUpdate().execute(url);
    stream.listen((OtaEvent event) {
      callback(event);
    }, onError: (error) {
      Fluttertoast.showToast(msg: "下载安装报包异常！");
    }, onDone: () {
      Fluttertoast.showToast(msg: "安装包下载成功！");
    });
  }
}
