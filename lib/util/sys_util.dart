import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SysUtil {
  static void setStatusBarBright() {
    // 设置 Android 头部的导航栏透明
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
