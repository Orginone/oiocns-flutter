import 'dart:async';

import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/index.dart';

import 'task.dart';

/// 任务集合名
const TaskCollName = 'work-task';

abstract class IWorkProvider {
  late String userId;

  /// 当前用户
  late UserProvider user;

  /// 待办
  late List<IWorkTask> todos;
  // 所有
  late List<IWorkTask> tasks;
  late Emitter notity;

  /// 任务更新
  void updateTask(XWorkTask task);

  /// 加载实例详情
  Future<XWorkInstance?> loadInstanceDetail(
    String id,
    String belongId,
  );

  /// 加载待办任务
  Future<List<IWorkTask>> loadTodos({bool reload = false});

  /// 加载任务数量
  Future<int> loadTaskCount(TaskType type);

  /// 加载任务事项
  Future<List<IWorkTask>> loadContent(TaskType type, {bool reload = false});
}

class WorkProvider implements IWorkProvider {
  WorkProvider(this.user) {
    kernel.on('RecvTask', [
      (XWorkTask data) {
        if (_todoLoaded && data.approveType != '抄送') {
          // var work = XWorkTask.fromJson(data);
          updateTask(data);
        }
      }
    ]);
  }
  @override
  final UserProvider user;
  @override
  List<IWorkTask> todos = [];
  @override
  List<IWorkTask> tasks = [];
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
  Future<List<IWorkTask>> loadContent(TaskType type,
      {bool reload = false}) async {
    if (type.label == '待办事项') {
      return await loadTodos(reload: reload);
    }
    return await loadTasks(type, reload: reload);
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

  Future<List<IWorkTask>> loadTasks(TaskType type,
      {bool reload = false}) async {
    if (reload) {
      tasks = [];
    }
    //
    var skip = tasks.where((i) => i.isTaskType(type)).toList().length;
    var result = await kernel.collectionLoad<List<XWorkTask>>(
      userId,
      [],
      TaskCollName,
      {
        'options': {
          'match': _typeMatch(type),
          'sort': {
            'createTime': -1,
          },
        },
        'skip': skip,
        'take': 30,
      },
      fromJson: (data) {
        LogUtil.d(data);
        // return [];
        return XWorkTask.fromList(data['data'] is List ? data['data'] : []);
      },
    );
    if (result.success && result.data != null && result.data!.isNotEmpty) {
      result.data?.forEach((item) => {
            if (tasks.every((i) => i.id != item.id))
              {tasks.add(WorkTask(item, user))}
          });
    }
    var ts = tasks.where((i) => i.isTaskType(type)).toList();
    return ts;
  }

  @override
  Future<int> loadTaskCount(TaskType type) async {
    var res = await kernel.collectionLoad(
        userId,
        [],
        TaskCollName,
        {
          "options": {
            "match": _typeMatch(type),
          },
          "isCountQuery": true,
        });
    if (res.success) {
      return res.totalCount;
    }
    return 0;
  }

  @override
  Future<XWorkInstance?> loadInstanceDetail(String id, String belongId) async {
    return await kernel.findInstance(belongId, id);
  }

  _typeMatch(TaskType type) {
    switch (type.label) {
      case '已办事项':
        return {
          'status': {
            '_gte_': 100,
          },
          'records': {
            '_exists_': true,
          },
        };
      case '我发起的':
        return {
          'createUser': userId,
          'nodeId': {
            '_exists_': false,
          },
        };
      case '抄送我的':
        return {
          'approveType': '抄送',
        };
      default:
        return {
          'status': {
            '_lt_': 100,
          },
        };
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
