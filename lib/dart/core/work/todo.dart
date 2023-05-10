

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/market/model.dart';

/// Todo接口
abstract class ITodo {
  /// 数据
  late XWorkTask metadata;

  /// 获取实例
  Future<XWorkInstance?> getInstance();

  /// 审批办事
  Future<bool> approval(int status, {String? comment, String? data});
}

class WorkTodo implements ITodo {
  WorkTodo(this.metadata){

  }

  @override
  late XWorkTask metadata;


  SettingController get setting => Get.find();

  @override
  Future<bool> approval(int status, {String? comment, String? data}) async{
    var res = await kernel.approvalTask(ApprovalTaskReq( id: metadata.id,
      comment: comment,
      status: status,
      data: data,));
    if (res.success) {
      setting.user.todos.removeWhere((a) => a.metadata.id == metadata.id);
      setting.user.todos.refresh();
    }
    return res.success;
  }

  @override
  Future<XWorkInstance?> getInstance() async{
    var res = await kernel.queryWorkInstanceById(IdReq(id: metadata.instanceId!));
    return res.data;
  }

}