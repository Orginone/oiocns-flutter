import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/util/encryption_util.dart';
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

  static void update(String prefix, Function callback) {
    prefix = EncryptionUtil.encodeURLString(prefix);
    String params = "shareDomain=all&prefix=$prefix&preview=False";
    String url = "${Constant.bucket}/Download?$params";
    log.info("======>updateURL:$url");
    var stream = OtaUpdate().execute(url);
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
