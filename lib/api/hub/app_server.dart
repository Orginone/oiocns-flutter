import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';

enum Event {
  connStateChange("connStateChange"),
  request("Request"),
  requests("Requests"),
  stopService("stopService");

  const Event(this.keyWord);

  final String keyWord;
}

class AppServer {
  final Logger log = Logger("AppServer");
  final FlutterBackgroundService _service;

  AppServer._(this._service);

  static AppServer? _instance;

  static AppServer get getInstance {
    _instance ??= AppServer._(FlutterBackgroundService());
    return _instance!;
  }

  static initialization() async {
    var appServer = getInstance;

    // 创建通知管道
    var channel = AndroidNotificationChannel(
      channelId,
      channelName,
      importance: Importance.low,
    );
    var plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 配置并启动后台实例
    await _instance!._service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: channelId,
        initialNotificationTitle: initialTitle,
        initialNotificationContent: initialContent,
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  invoke(String event, {List<Object>? args}) {
    _service.invoke(event, {"args": args});
  }

  on(String event, void Function(List<dynamic>) func) {
    _service.on(event).listen((data) {
      if (data == null) return;
      if (data["args"] == null) return;
      log.info("接受到的消息为：${data.toString()}");
      func(data["args"]);
    });
  }
}

String channelId = "orginone_notification";
String channelName = "奥集能通知";
String initialTitle = "奥集能服务";
String initialContent = "奥集能服务正在初始化中...";
int notificationId = 888;

void logInfo(String msg) {
  if (kDebugMode) {
    print("acelogInfo******************************$msg******");
  }
}

/// 开启服务
@pragma('vm:entry-point')
onStart(ServiceInstance service) async {
  logInfo("====background=====> onStart");

  // 初始化插件
  DartPluginRegistrant.ensureInitialized();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
