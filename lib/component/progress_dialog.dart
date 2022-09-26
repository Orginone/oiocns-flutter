import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:ota_update/ota_update.dart';

class ProgressDialog extends Dialog {
  final String content;

  const ProgressDialog(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [image, description, confirmBtn],
      ),
    );
  }

  get image => const Align(
        alignment: Alignment.topCenter,
        child: Image(
          image: AssetImage("images/logo.png"),
        ),
      );

  get description => Align(
        alignment: Alignment.center,
        child: Text(
          content,
          style: text20,
        ),
      );

  get confirmBtn => Align(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("确认更新"),
        ),
      );

  void _downloadPackage() {
    SysUtil.update((OtaEvent event) {
      OtaStatus status = event.status;
      String? value = event.value;
      switch (status) {
        case OtaStatus.DOWNLOADING:
          int progress = int.parse(value ?? "0");
          var android = const AndroidNotificationDetails(
            'DownloadNotification',
            '下载通知',
            priority: Priority.max,
            importance: Importance.max,
            showProgress: true,
          );
          var notificationDetails = NotificationDetails(android: android);
          FlutterLocalNotificationsPlugin()
              .show(0, "安裝包", null, notificationDetails);
          break;
        case OtaStatus.INSTALLING:
          // TODO: Handle this case.
          break;
        case OtaStatus.ALREADY_RUNNING_ERROR:
          // TODO: Handle this case.
          break;
        case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
          // TODO: Handle this case.
          break;
        case OtaStatus.INTERNAL_ERROR:
          // TODO: Handle this case.
          break;
        case OtaStatus.DOWNLOAD_ERROR:
          // TODO: Handle this case.
          break;
        case OtaStatus.CHECKSUM_ERROR:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
