import 'package:get/get.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/base/model.dart';
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
  Future<bool> approval(ITodo todo, int status, String comment, String data);
}

class Work extends IWork {
  RxList<ITodo> orgTodo = <ITodo>[].obs;
  RxList<ITodo> flowTodo = <ITodo>[].obs;

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
    orgTodo.value = orgTodo.where((a) => !todos.contains(a)).toList();
    flowTodo.value = flowTodo.where((a) => !todos.contains(a)).toList();
    return true;
  }

  @override
  Future<bool> approval(
    ITodo todo,
    int status,
    String comment,
    String data,
  ) async {
    var success = false;
    if (await todo.approval(status, comment, data)) {
      orgTodo.value = orgTodo.where((a) => a.id != todo.id).toList();
      flowTodo.value = flowTodo.where((a) => a.id != todo.id).toList();
    }
    return success;
  }

  @override
  Future<List<ITodo>> loadTodo({bool reload = false}) async {
    if (reload || orgTodo.isEmpty) {
      var org = await kernelApi.queryTeamJoinApproval(IDBelongReq(
        id: '0',
        page: pageAll(),
      ));
      if (org.success) {
        orgTodo.value = org.data?.result?.map((a) => OrgTodo(a)).toList() ?? [];
      }
    }
    if (reload || flowTodo.isEmpty) {
      var res = await kernelApi.queryApproveTask();
      if (res.success) {
        flowTodo.value = res.data?.result?.map((a) => FlowTodo(a)).toList() ?? [];
      }
    }
    return [...this.orgTodo, ...this.flowTodo];
  }
}
