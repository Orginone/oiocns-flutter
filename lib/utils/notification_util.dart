import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/string_util.dart';

const notificationChannelId = 'orginone';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

const android = AndroidInitializationSettings('@mipmap/ic_launcher');
const ios = DarwinInitializationSettings();

const initRelations = InitializationSettings(android: android, iOS: ios);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationUtil {
  static int nId = 0;
  static Future<void> initializeService() async {
    flutterLocalNotificationsPlugin.initialize(initRelations);
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        notificationChannelId, // id
        '新消息通知', // title
        description: '奥集能收到新消息时使用的通知类别',
        // importance: Importance.low,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static void showChatMessageNotification(IMessage msg) async {
    // ShareIcon share = relationCtrl.user.findShareById(msg.metadata.fromId);
    showMsgNotification(msg.id, "${msg.from.name}发来一条消息",
        StringUtil.msgConversion(msg, relationCtrl.user?.id ?? ""));
  }

  static void showMsgNotification(String id, String title, String body) {
    LogUtil.d('>>>===悬浮通知$id $nId');
    // [Permission.notification, Permission.storage].request().then((val) {
    //   LogUtil.d('>>>===$val');
    //   if (PermissionStatus.granted == val) {
    flutterLocalNotificationsPlugin.show(
      nId++,
      title,
      body,
      const NotificationDetails(
          android: AndroidNotificationDetails(
            notificationChannelId,
            '',
            icon: 'ic_bg_service_small',
          ),
          iOS: DarwinNotificationDetails(
              threadIdentifier: notificationChannelId)),
    );
    //   }
    // });
  }
}

Future<void> onStart(service) async {
  DartPluginRegistrant.ensureInitialized();

  if (Platform.isAndroid) {
    // Timer.periodic(const Duration(seconds: 3), (timer) async {
    LogUtil.d('>>>===奥集能前台进程运行中');
    // });
  }
}
