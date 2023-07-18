
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/logic.dart';
import 'package:orginone/pages/work/state.dart';

import 'index.dart';
import 'task.dart';

abstract class IWorkProvider {

  late String userId;

  /// 当前用户
  late UserProvider user;

  /// 待办
  late RxList<IWorkTask> todos;

  late RxList<WorkFrequentlyUsed> workFrequentlyUsed;

  /// 加载待办任务
  Future<List<IWorkTask>> loadTodos({bool reload = false});

  /// 加载已办任务
  Future<List<IWorkTask>> loadDones(String id);

  /// 加载我发起的办事任务
  Future<List<IWorkTask>> loadApply(String id);

  /// 任务更新
  void updateTask(XWorkTask task);

  /// 查询流程定义
  Future<IWork?> findFlowDefine(String defineId);

  ///根据表单id查询表单特性
  Future<List<XAttribute>> loadAttributes(String id, String belongId);

  ///根据字典id查询字典项
  Future<List<XDictItem>> loadItems(String id);

  //加载常用
  Future<void> loadMostUsed();

  //设为常用
  Future<void> setMostUsed(IWork define);

  //移除常用
  Future<void> removeMostUsed(IWork define);

  //是否常用
  bool isMostUsed(IWork define);
}

class WorkProvider implements IWorkProvider{


  WorkProvider(this.user){
    userId = user.user!.id;
    todos = <IWorkTask>[].obs;
    kernel.on('RecvTask', (data) {
      var work = XWorkTask.fromJson(data);
      updateTask(work);
    });
    workFrequentlyUsed = <WorkFrequentlyUsed>[].obs;
  }

  @override
  late RxList<IWorkTask> todos;

  @override
  late UserProvider user;

  @override
  late RxList<WorkFrequentlyUsed> workFrequentlyUsed;

  @override
  // TODO: implement userId
  late String userId;

  @override
  Future<IWork?> findFlowDefine(String defineId) async{
    for (final target in user.targets) {
      for (final application in target.directory.applications) {
        for (final define in application.works) {
          if (define.metadata.id == defineId) {
            return define;
          }
        }
      }
    }
    return null;
  }

  @override
  Future<List<IWorkTask>> loadApply(String id) async{
    var res = await kernel.anystore.pageRequest('work-tasks',userId,{
      "match": {
        "belongId": id,
        "createUser": userId,
        "nodeId": {
          "_exists_": false,
        },
      },
      "sort": {
        "createTime": -1,
      },
    },PageRequest(offset: 0, limit: 9999, filter: ''));
    return res.map((e) => WorkTask(e, user)).toList();
  }

  @override
  Future<List<IWorkTask>> loadDones(String id) async{
    var res = await kernel.anystore.pageRequest('work-tasks',userId,{
      "match": {
        "belongId": id,
        "status": {
          "_gte_": 100,
        },
        "records": {
          "_exists_": true,
        },
      },
      "sort": {
        "createTime": -1,
      },
    },PageRequest(offset: 0, limit: 9999, filter: ''));
    return res.map((e) => WorkTask(e, user)).toList();
  }


  @override
  Future<List<IWorkTask>> loadTodos({bool reload = false}) async{
    if (todos.isEmpty || reload) {
      final res = await kernel.queryApproveTask(IdReq(id: '0'));
      if (res.success) {
        todos.clear();
        todos.addAll((res.data?.result??[]).map((e) => WorkTask(e, user)).toList());
        todos.refresh();
      }
    }
    return todos;
  }

  @override
  void updateTask(XWorkTask task) {
    final index = todos.indexWhere((i) => i.metadata.id == task.id);
    if (task.status != TaskStatus.approvalStart.status) {
      if (index < 0) {
        todos.insert(0, WorkTask(task, user));
      } else {
        todos[index].updated(task);
      }
    } else if (index > -1) {
      todos.removeAt(index);
    }
    todos.refresh();
  }

  @override
  Future<List<XAttribute>> loadAttributes(String id, String belongId) async {
    var res = await kernel.queryFormAttributes(GainModel(
      id: id,
      subId: belongId,
    ));
    if (res.success) {
      return res.data?.result ?? [];
    }
    return [];
  }

  @override
  Future<List<XDictItem>> loadItems(String id) async {
    var res = await kernel.queryDictItems(IdReq(id: id));
    if (res.success) {
      return res.data?.result ?? [];
    }
    return [];
  }

  @override
  Future<void> loadMostUsed() async {
    var res = await kernel.anystore.get(
      "${StoreCollName.mostUsed}.works",
      userId,
    );
    if (res.success && res.data != null) {
      workFrequentlyUsed.clear();
      var works = res.data;
      if (works is Map<String, dynamic>) {
        for (var key in works.keys) {
          var defineId = key.substring(1);
          var define = await findFlowDefine(defineId);
          if (define != null) {
            workFrequentlyUsed.add(WorkFrequentlyUsed(
                define: define,
                name: define.metadata.name,
                id: define.metadata.id,
                avatar: define.metadata.avatarThumbnail()));
          }
        }
      }
    }
  }

  @override
  Future<void> removeMostUsed(IWork define) async {
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.works.T${define.metadata.code}",
      {},
      userId,
    );
    if (res.success) {
      workFrequentlyUsed.removeWhere((p0) => p0.id == define.metadata.id);
      workFrequentlyUsed.refresh();
    }
  }

  @override
  Future<void> setMostUsed(IWork define) async {
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.works.T${define.metadata.id}",
      {},
      userId,
    );
    if (res.success) {
      WorkFrequentlyUsed used = WorkFrequentlyUsed(
          define: define,
          name: define.metadata.name,
          id: define.metadata.id,
          avatar: define.metadata.avatarThumbnail());
      workFrequentlyUsed.add(used);
      workFrequentlyUsed.refresh();
    }
  }

  @override
  bool isMostUsed(IWork define) {
    return workFrequentlyUsed.where((p0) => p0.id == define.metadata.id).isNotEmpty;
  }
}