import 'dart:ui';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/utils/toast_utils.dart';

class WorkNetWork {
  static Future<void> approvalTask(
      {required IWorkTask todo,
      required int status,
      String? comment,
      VoidCallback? onSuccess}) async {
    try {
      bool success = await todo.approvalTask(status, comment: comment);
      if (success) {
        ToastUtils.showMsg(msg: "操作成功");
        await Future.delayed(const Duration(milliseconds: 100));
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } catch (e) {
      ToastUtils.showMsg(msg: "审核异常");
    }
  }
}
