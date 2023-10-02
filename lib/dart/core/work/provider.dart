import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/state.dart';

import 'task.dart';

abstract class IWorkProvider {
  late String userId;

  /// 当前用户
  late UserProvider user;

  /// 待办
  late List<IWorkTask> todos;
  late Emitter notity;
  late List<WorkFrequentlyUsed> workFrequentlyUsed;

  /// 加载待办任务
  Future<List<IWorkTask>> loadTodos({bool reload = false});

  /// 加载已办任务
  Future<PageResult<IWorkTask>> loadDones(IdPageModel req);

  /// 加载我发起的办事任务
  Future<PageResult<IWorkTask>> loadApply(IdPageModel req);

  /// 任务更新
  void updateTask(XWorkTask task);

  /// 加载实例详情
  Future<XWorkInstance?> loadInstanceDetail(
    String id,
    String belongId,
  );
}

class WorkProvider implements IWorkProvider {
  WorkProvider(this.user) {
    kernel.on('RecvTask', [
      (data) {
        if (!_todoLoaded) {}
        var work = XWorkTask.fromJson(data);
        updateTask(work);
      }
    ]);

    workFrequentlyUsed = <WorkFrequentlyUsed>[].obs;
  }
  @override
  final UserProvider user;
  @override
  List<IWorkTask> todos = [];
  @override
  Emitter notity = Emitter();

  @override
  String get userId => user.user!.id;
  bool _todoLoaded = false;

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
    notity.changCallback();
  }

  @override
  Future<List<IWorkTask>> loadTodos({bool reload = false}) async {
    if (!_todoLoaded || reload) {
      final res = await kernel.queryApproveTask(IdModel('0'));
      if (res.success) {
        _todoLoaded = true;
        todos = (res.data?.result ?? [])
            .map((task) => WorkTask(task, user))
            .toList();
        notity.changCallback();
      }
    }
    return todos;
  }

  @override
  Future<PageResult<IWorkTask>> loadDones(IdPageModel req) async {
    var res = await kernel.collectionPageRequest<XWorkTask>(
        userId,
        [userId],
        storeCollName['workTask']!,
        {
          "match": {
            "belongId": req.id,
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
        },
        pageAll);
    List<WorkTask> result = (res.data?.result ?? [])
        .where((i) => i.records != null && i.records!.isNotEmpty)
        .toList()
        .map((i) => WorkTask(i, user))
        .toList();
    return PageResult<IWorkTask>(
        total: res.data!.total,
        offset: res.data!.offset,
        limit: res.data!.limit,
        result: result);
  }

  @override
  Future<PageResult<IWorkTask>> loadApply(IdPageModel req) async {
    var res = await kernel.collectionPageRequest<XWorkTask>(
        userId,
        [userId],
        storeCollName['workTask']!,
        {
          "match": {
            "belongId": req.id,
            "createUser": userId,
            "nodeId": {
              "_exists_": false,
            },
          },
          "sort": {
            "createTime": -1,
          },
        },
        pageAll);
    List<WorkTask> result =
        (res.data?.result ?? []).map((task) => WorkTask(task, user)).toList();
    return PageResult<IWorkTask>(
        total: res.data!.total,
        offset: res.data!.offset,
        limit: res.data!.limit,
        result: result);
  }

  @override
  Future<XWorkInstance?> loadInstanceDetail(
    String id,
    String belongId,
  ) async {
    final res = await kernel.collectionAggregate(
      belongId,
      [belongId],
      storeCollName['workInstance']!,
      {
        'match': {
          id: id,
        },
        'limit': 1,
        'lookup': {
          'from': storeCollName['workTask'],
          'localField': 'id',
          'foreignField': 'instanceId',
          'as': 'tasks',
        },
      },
    );
    if (res.data && res.data.length > 0) {
      return res.data[0];
    }
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
