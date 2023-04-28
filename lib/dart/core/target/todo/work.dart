import 'package:get/get.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/todo/todo.dart';
import 'package:orginone/main.dart';

abstract class IWork {
  late List<ITodo> todos;

  /// 查询待办
  Future<List<ITodo>> loadTodo({bool reload});

  /// 批量审批办事
  Future<bool> approvals(
    List<ITodo> todos,
    int status,
    String comment,
    String data,
  );

  /// 审批办事
  Future<bool> approval(ITodo todo, int status, String? comment, String? data);
}

class Work extends IWork {
  List<ITodo> orgTodo = [];
  List<ITodo> flowTodo = [];
  SettingController setting = Get.find<SettingController>();

  Work(){
    todos = [];
  }
  @override
  Future<bool> approvals(
    List<ITodo> todos,
    int status,
    String comment,
    String data,
  ) async {
    for (var todo in todos) {
      await todo.approval(status, comment, data);
    }
    orgTodo = orgTodo.where((a) => !todos.contains(a)).toList();
    flowTodo = flowTodo.where((a) => !todos.contains(a)).toList();
    todos = [...orgTodo,...flowTodo];
    setting.provider.refresh();
    return true;
  }

  @override
  Future<bool> approval(
    ITodo todo,
    int status,
    String? comment,
    String? data,
  ) async {
    var success = await todo.approval(status, comment, data);
    if (success) {
      orgTodo = orgTodo.where((a) => a.id != todo.id).toList();
      flowTodo = flowTodo.where((a) => a.id != todo.id).toList();
      todos = [...orgTodo,...flowTodo];
      setting.provider.refresh();
    }
    return success;
  }

  @override
  Future<List<ITodo>> loadTodo({bool reload = false}) async {
    if (reload || orgTodo.isEmpty) {
      var org = await kernel.queryTeamJoinApproval(IDBelongReq(
        id: '0',
        page: pageAll(),
      ));
      if (org.success) {
        orgTodo = org.data?.result?.map((a) => OrgTodo(a)).toList() ?? [];
      }
    }
    if (reload || flowTodo.isEmpty) {
      var res = await kernel.queryApproveTask();
      if (res.success) {
        flowTodo = res.data?.result?.map((a) => FlowTodo(a)).toList() ?? [];
      }
    }
    todos = [...orgTodo, ...flowTodo];
    setting.provider.refresh();
    return todos;
  }
}
