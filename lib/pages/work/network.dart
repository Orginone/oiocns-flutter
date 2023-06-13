import 'dart:ui';

import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/toast_utils.dart';



class WorkNetWork {

  static Future<List<XWorkTask>> getTodo() async {
    var result = await settingCtrl.provider.work?.loadTodos(reload: true);
    return result??[];
  }

  static Future<List<XWorkTask>> getDones(String id) async {
    var result = await settingCtrl.provider.work?.loadDones(id);
    return result??[];
  }

  static Future<List<XWorkTask>> getApply(String id) async {
    var result = await settingCtrl.provider.work?.loadApply(id);
    return result??[];
  }

  static Future<XWorkInstance?> getFlowInstance(XWorkTask todo) async {
    XWorkInstance? flowInstance = await settingCtrl.provider.work?.loadTaskDetail(todo);
    return flowInstance;
  }

  static Future<IWorkDefine?> getFlowDefine(XWorkTask todo) async {
    IWorkDefine? define = await settingCtrl.provider.work?.findFlowDefine(todo.defineId!);
    return define;
  }


  static Future<void> approvalTask(
      {required XWorkTask todo, required int status, String? comment,VoidCallback? onSuccess}) async {

    bool success = await settingCtrl.provider.work!.approvalTask([todo],status,comment: comment);
    if (success) {
      ToastUtils.showMsg(msg: "成功");
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }
}
