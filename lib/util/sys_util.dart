import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:orginone/widget/unified.dart';
import 'package:ota_update/ota_update.dart';

class SysUtil {
  static Logger log = Logger("SysUtil");

  static void setStatusBarBright() {
    if(kIsWeb)return;
    // 设置 Android 头部的导航栏透明
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
          statusBarColor: XColors.navigatorBgColor,
          statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  static void update(String path, Function callback) {
    log.info("======>updateURL:$path");
    var stream = OtaUpdate().execute(path);
    stream.listen((OtaEvent event) {
      callback(event);
    }, onError: (error) {
      Fluttertoast.showToast(msg: "下载安装报包异常！");
      throw error;
    }, onDone: () {
      Fluttertoast.showToast(msg: "安装包下载成功！");
    });
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
}
