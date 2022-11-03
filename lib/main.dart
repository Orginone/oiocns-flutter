import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:orginone/screen_init.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:orginone/util/notification_util.dart';

void main() async {
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // 开启 app
  runApp(const ScreenInit());
}
