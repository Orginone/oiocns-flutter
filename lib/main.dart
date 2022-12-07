import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/hub/app_server.dart';
import 'package:orginone/screen_init.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:orginone/util/notification_util.dart';

void main() async {
  FlutterBugly.postCatchedException(() async {
    // 逻辑绑定
    WidgetsFlutterBinding.ensureInitialized();

    // 初始化 hive
    await HiveUtil().init();

    // 初始化通知配置
    NotificationUtil.initNotification();

    // 日志初始化
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((event) {
      if (kDebugMode) {
        print('${event.level.name}: ${event.time}: ${event.message}');
      }
    });

    await AppServer.initialization();

    // 开启 app
    runApp(const ScreenInit());

    // 日志收集工具
    FlutterBugly.init(
      androidAppId: "e36da6d5e9",
      iOSAppId: "af89f332-ed6c-42dc-8eb1-fb63cea1a39d",
    );
  }, debugUpload: true);
}
