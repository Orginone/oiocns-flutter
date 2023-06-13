


import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
import 'package:orginone/dart/core/thing/market/market.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/state.dart';

abstract class IWorkProvider {
  /// 当前用户
  late IPerson user;

  /// 待办
  late RxList<XWorkTask> todos;

  late RxList<WorkRecent> workRecent;

  /// 加载待办任务
  Future<List<XWorkTask>> loadTodos({bool reload = false});

  /// 加载已办任务
  Future<List<XWorkTask>> loadDones(String id);

  /// 加载我发起的办事任务
  Future<List<XWorkTask>> loadApply(String id);

  /// 任务更新
  void updateTask(XWorkTask task);

  /// 任务审批
  Future<bool> approvalTask(List<XWorkTask> tasks, int status,
      {String? comment, String? data});

  /// 查询任务明细
  Future<XWorkInstance?> loadTaskDetail(XWorkTask task);

  /// 查询流程定义
  Future<IWorkDefine?> findFlowDefine(String defineId);

  ///删除办事实例
  Future<bool> deleteInstance(String id);

  ///根据表单id查询表单特性
  Future<List<XAttribute>> loadAttributes(String id, String belongId);

  ///根据字典id查询字典项
  Future<List<XDictItem>> loadItems(String id);

  Future<void> loadMostUsed();

  Future<void> setMostUsed(IWorkDefine define);

  Future<void> removeMostUsed(IWorkDefine define);

  bool isMostUsed(IWorkDefine define);
}

class WorkProvider implements IWorkProvider{


  WorkProvider(this.user){
    todos = <XWorkTask>[].obs;
    kernel.on('RecvTask', (data) {
      var work = XWorkTask.fromJson(data);
      updateTask(work);
    });
    workRecent = RxList();
  }

  @override
  late RxList<XWorkTask> todos;

  @override
  late IPerson user;

  @override
  late RxList<WorkRecent> workRecent;

  @override
  Future<bool> approvalTask(List<XWorkTask> tasks, int status,
      {String? comment, String? data}) async {
    bool success = true;
    for (final task in tasks) {
      if (task.status < TaskStatus.approvalStart.status) {
        if (status == -1) {
          success =
              (await kernel.recallWorkInstance(IdReq(id: task.id))).success;
        } else {
          success = (await kernel.approvalTask(ApprovalTaskReq(
                  id: task.id, status: status, comment: comment, data: data)))
              .success;
        }
        if(success){
          todos.removeWhere((element) => element.id == task.id);
          todos.refresh();
        }
      }
    }
    return success;
  }

  @override
  Future<IWorkDefine?> findFlowDefine(String defineId) async{
    for (final target in user.targets) {
      for (final species in target.species) {
        final defines = <IWorkDefine>[];
        switch (SpeciesType.getType(species.metadata.typeName)) {
          case SpeciesType.market:
            defines.addAll(await (species as IMarket).loadWorkDefines());
            break;
          case SpeciesType.application:
            defines.addAll(await (species as IApplication).loadWorkDefines());
            break;
        }
        for (final define in defines) {
          if (define.metadata.id == defineId) {
            return define;
          }
        }
      }
    }
    return null;
  }

  @override
  Future<List<XWorkTask>> loadApply(String id) async{
    var res = await kernel.anystore.pageRequest('work-task',user.id,{
      "match": {
        "belongId": id,
        "createUser": user.id,
        "nodeId": {
          "_exists_": false,
        },
      },
      "sort": {
        "createTime": -1,
      },
    },PageRequest(offset: 0, limit: 9999, filter: ''));
    return res;
  }

  @override
  Future<List<XWorkTask>> loadDones(String id) async{
    var res = await kernel.anystore.pageRequest('work-task',user.id,{
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
    return res;
  }

  @override
  Future<XWorkInstance?> loadTaskDetail(XWorkTask task) async{
    final res = await kernel.queryWorkInstanceById(IdReq(id: task.instanceId));
    return res.data;
  }

  @override
  Future<List<XWorkTask>> loadTodos({bool reload = false}) async{
    if (todos.isEmpty || reload) {
      final res = await kernel.queryApproveTask(IdReq(id: '0'));
      if (res.success) {
        todos.clear();
        todos.addAll(res.data?.result??[]);
        todos.refresh();
      }
    }
    return todos;
  }

  @override
  void updateTask(XWorkTask task) {
    final index = todos.indexWhere((i) => i.id == task.id);
    if (task.status != TaskStatus.approvalStart.status) {
      if (index < 0) {
        todos.insert(0, task);
      } else {
        todos[index] = task;
      }
    } else if (index > -1) {
      todos.removeAt(index);
    }
    todos.refresh();
  }

  @override
  Future<bool> deleteInstance(String id) async {
    var res = await kernel.recallWorkInstance(IdReq(id: id));
    return res.success;
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
      user.id,
    );
    if (res.success && res.data != null) {
      workRecent.clear();
      var works = res.data;
      if (works is Map<String, dynamic>) {
        for (var key in works.keys) {
          var defineId = key.substring(1);
          var define = await findFlowDefine(defineId);
          if (define != null) {
            workRecent.add(WorkRecent(
                define: define,
                name: define.metadata.name,
                id: define.metadata.id,
                avatar: define.share.avatar?.thumbnailUint8List));
          }
        }
      }
    }
  }

  @override
  Future<void> removeMostUsed(IWorkDefine define) async {
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.works.T${define.metadata.code}",
      {},
      user.id,
    );
    if (res.success) {
      workRecent.removeWhere((p0) => p0.id == define.metadata.id);
      workRecent.refresh();
    }
  }

  @override
  Future<void> setMostUsed(IWorkDefine define) async {
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.works.T${define.metadata.id}",
      {},
      user.id,
    );
    if (res.success) {
      WorkRecent recent = WorkRecent(
          define: define,
          name: define.metadata.name,
          id: define.metadata.id,
          avatar: define.share.avatar?.thumbnailUint8List);
      workRecent.add(recent);
    }
  }

  @override
  bool isMostUsed(IWorkDefine define) {
    return workRecent.where((p0) => p0.id == define.metadata.id).isNotEmpty;
  }
}