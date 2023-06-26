import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/string_util.dart';

const notificationChannelId = 'orginone';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

const android = AndroidInitializationSettings('@mipmap/ic_launcher');
const ios = DarwinInitializationSettings();

const initSettings = InitializationSettings(android: android, iOS: ios);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationUtil {
  static Future<void> initializeService() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      '', // title
      description: '',
      importance: Importance.low,
    );
    flutterLocalNotificationsPlugin.initialize(initSettings);
    if(Platform.isAndroid){
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    if(Platform.isIOS){
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: '通知状态',
        initialNotificationContent: '开启',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
  }

  static void showMsgNotification(MsgSaveModel msg) async {
    ShareIcon share = await settingCtrl.user.findShareById(msg.fromId);
    flutterLocalNotificationsPlugin.show(
      notificationId,
      "${share.name}发来一条消息",
      StringUtil.msgConversion(msg, settingCtrl.user.id),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          '',
          icon: 'ic_bg_service_small',
        ),
        iOS: DarwinNotificationDetails(threadIdentifier: notificationChannelId)
      ),
    );
  }
}

Future<void> onStart(service) async {
  DartPluginRegistrant.ensureInitialized();

  if(Platform.isAndroid){
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      print('爱共享前台进程运行中');
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          notificationId,
          '爱共享',
          '正在运行中',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              '前台消息',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    });
  }
}
