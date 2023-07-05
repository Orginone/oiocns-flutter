import 'dart:ui';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/toast_utils.dart';



class WorkNetWork {

  static Future<List<IWorkTask>> getTodo() async {
    var result = await settingCtrl.provider.work?.loadTodos(reload: true);
    return result??[];
  }

  static Future<List<IWorkTask>> getDones(String id) async {
    var result = await settingCtrl.provider.work?.loadDones(id);
    return result??[];
  }

  static Future<List<IWorkTask>> getApply(String id) async {
    var result = await settingCtrl.provider.work?.loadApply(id);
    return result??[];
  }

  static Future<XWorkInstance?> getFlowInstance(IWorkTask todo) async {
    bool success = await todo.loadInstance(reload: true);
    if(success){
      return todo.instance;
    }
    return null;
  }

  static Future<IWork?> getFlowDefine(IWorkTask todo) async {
    IWork? define = await settingCtrl.provider.work?.findFlowDefine(todo.metadata.defineId);
    return define;
  }


  static Future<void> approvalTask(
      {required IWorkTask todo, required int status, String? comment,VoidCallback? onSuccess}) async {

    bool success = await todo.approvalTask(status,comment: comment);
    if (success) {
      ToastUtils.showMsg(msg: "成功");
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }
}
