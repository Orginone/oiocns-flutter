import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> hasCamera() async {
    late PermissionStatus status;

    if (Platform.isIOS) {
      status = await Permission.camera.status;
    } else if (Platform.isAndroid) {
      status = await Permission.camera.status;
    } else {
      throw Exception("暂不支持的平台");
    }

    return status == PermissionStatus.granted;
  }

  static showConfirmDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('您需要授予相册权限'),
          content: const Text("请转到您的手机设置打开相应相册的权限"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('前去设置'),
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
