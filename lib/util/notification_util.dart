import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';

class NotificationUtil {
  static Logger log = Logger("SysUtil");

  static void _receiveNotification(NotificationResponse response) {
    log.info("====> 通知回调：$response");
  }

  static void _receiveNotificationBackground(NotificationResponse response) {
    log.info("====> 后台通知回调：$response");
  }

  static initNotification() {
    var plugin = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: android);
    plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _receiveNotification,
      onDidReceiveBackgroundNotificationResponse:
          _receiveNotificationBackground,
    );
  }

  static void showNewMsg(String name, String showTxt) {
    var android = const AndroidNotificationDetails(
      'NewMessageNotification',
      '新消息通知',
      priority: Priority.max,
      importance: Importance.max,
      playSound: true,
    );
    var notificationDetails = NotificationDetails(android: android);
    var plugin = FlutterLocalNotificationsPlugin();
    plugin.show(0, name, showTxt, notificationDetails);
  }
}
