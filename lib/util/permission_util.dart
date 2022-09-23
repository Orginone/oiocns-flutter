import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static final Map<Permission, String> permissionNameMap = {
    Permission.camera: "相册",
  };

  static showPermissionDialog(BuildContext context, Permission permission) {
    var name = permissionNameMap[permission];
    String title = '您需要授予$name权限';
    String content = '"请转到您的手机设置打开相应$name的权限"';

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
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
