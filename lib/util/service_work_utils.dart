import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:orginone/api/hub/store_hub.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';


///
///1.电量优化
///2.自启动
///3.miui问题展示无法解决，要看后面的情况
///4.ios机制问题需要处理：Simulate Background Fetch
///5.优化处理登录问题之后
///6.12之后的前台服务问题

void logInfo(String msg) {
  print("acelogInfo******************************$msg******");
}

void logError(String msg) {
  print(msg);
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// 可选，使用自定义通知通道id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'oiocns_notification',
    'oiocns_notification',
    description: 'oiocns_notification.',
    importance: Importance.low,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'oiocns_notification',
      initialNotificationTitle: 'oiocns service',
      initialNotificationContent: 'oiocns service initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground:
          onIosBackground, // you have to enable background fetch capability on xcode project
    ),
  );
  // service.startService();
}

// 以确保执行
// 从xcode运行应用程序，然后从xcode菜单中选择Simulate Background Fetch
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // 仅适用于颤振3.0.0及更高版本
  DartPluginRegistrant.ensureInitialized();

  logInfo("onStart");

  /// 使用自定义通知时可选
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      logInfo("setAsForeground: ${DateTime.now()}");
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      logInfo("setAsBackground: ${DateTime.now()}");
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    logInfo("stopService: ${DateTime.now()}");
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    logInfo("flutter service running  ${DateTime.now()}");

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// 可选使用自定义通知
        /// 调用configure（）方法时，通知id必须与AndroidConfiguration相等。
        flutterLocalNotificationsPlugin.show(
          888,
          'oiocns flutter',
          'oiocns flutter ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'oiocns_notification',
              'oiocns_notification',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }
  });
}

bool isCanConnectingFlag(StoreHub mStoreHub) {
  return mStoreHub.isDisConnected();
}

Future<void> openIgnoredBattery() async {
  try {
    if (Platform.isAndroid) {
      bool isIgnored = await OptimizeBattery.isIgnoringBatteryOptimizations();
      Fluttertoast.showToast(msg: "当前状态${isIgnored ? "已" : "未"}开启");
      if (!isIgnored) OptimizeBattery.openBatteryOptimizationSettings();
    }
  } catch (e) {
    logError("Error================================================\n$e");
  }
}

Future<void> openAutoStart() async {
  try {
    if (Platform.isAndroid) {
      bool? auto = await isAutoStartAvailable;
      auto ??= false;
      Fluttertoast.showToast(msg: "当前状态${auto ? "已" : "未"}开启");
      if (!auto) await getAutoStartPermission();
    }
  } catch (e) {
    logError("Error================================================\n$e");
  }
}
