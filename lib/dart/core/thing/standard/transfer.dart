import 'dart:convert';
import 'dart:io';

import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/encryption.dart';
import 'package:orginone/dart/base/common/objects.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/date_utils.dart';

typedef GraphData = dynamic Function();

/// 数据传输接口
abstract class ITransfer implements IStandardFileInfo<XTransfer> {
  /// 触发器
  late final Command command;

  /// 任务记录
  late List<ITask> taskList;

  /// 当前任务
  ITask? curTask;

  /// 获取实体
  ITransfer? getTransfer(String id);

  /// 取图数据
  GraphData? getData;

  /// 绑定图
  void binding(GraphData getData);

  /// 取消绑定
  void unbinding();

  /// 是否有环
  bool hasLoop();

  /// 获取节点
  Node? getNode(String id);

  /// 增加节点
  Future<void> addNode(Node node);

  /// 更新节点
  Future<void> updNode(Node node);

  /// 删除节点
  Future<void> delNode(String id);

  /// 获取边
  Edge? getEdge(String id);

  /// 增加边
  Future<bool> addEdge(Edge edge);

  /// 更新边
  Future<void> updEdge(Edge edge);

  /// 删除边
  Future<void> delEdge(String id);

  /// 新增环境
  Future<void> addEnv(Environment env);

  /// 修改环境
  Future<void> updEnv(Environment env);

  /// 删除环境
  Future<void> delEnv(String id);

  /// 当前环境
  Environment? getCurEnv();

  /// 变更环境
  Future<void> changeEnv(String id);

  /// 请求
  Future<HttpResponseType> request(Node node, {KeyValue? env});

  /// 脚本
  dynamic running(String code, dynamic args, {KeyValue? env});

  /// 映射
  Future<List<dynamic>> mapping(Node node, List<dynamic> array);

  /// 写入
  Future<List<dynamic>> writing(Node node, List<dynamic> array);

  /// 模板
  Future<List<Sheet<T>>> template<T>(Node node);

  /// 读取
  Future<dynamic> reading(Node node);

  /// 创建任务
  Future<void> execute(GStatus status, GEvent event);

  /// 创建任务
  Future<void> nextExecute(ITask preTask);
}

class Transfer extends StandardFileInfo<XTransfer> implements ITransfer {
  @override
  late Command command;
  @override
  late List<ITask> taskList;
  @override
  ITask? curTask;
  @override
  GraphData? getData;

  Transfer(XTransfer metadata, IDirectory dir)
      : super(metadata, dir, dir.resource.transferColl) {
    taskList = [];
    command = Command();
    setEntity();
  }

  @override
  String get cacheFlag {
    return 'transfers';
  }

  @override
  Future<void> execute(GStatus status, GEvent event) async {
    curTask = Task(this, event, status);
    taskList.add(curTask!);
    await curTask!.starting();
  }

  @override
  Future<void> nextExecute(ITask preTask) async {
    curTask = Task(this, preTask.initEvent, preTask.initStatus, task: preTask);
    taskList.add(curTask!);
    await curTask!.starting();
  }

  @override
  ITransfer? getTransfer(String id) {
    return getEntity(id) as ITransfer?;
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (allowCopy(destination)) {
      return await super
          .copyTo(destination.id, coll: destination.resource.transferColl);
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (allowCopy(destination)) {
      return await super
          .copyTo(destination.id, coll: destination.resource.transferColl);
    }
    return false;
  }

  @override
  bool hasLoop() {
    bool hasLoop(Node node, Set<String> chain) {
      for (var edge in metadata.edges) {
        if (edge.start == node.id) {
          for (var next in metadata.nodes) {
            if (edge.end == next.id) {
              if (chain.contains(next.id)) {
                return true;
              }
              if (hasLoop(next, {...chain, next.id})) {
                return true;
              }
            }
          }
        }
      }
      return false;
    }

    var not = metadata.edges.map((item) => item.end).toList();
    var roots = metadata.nodes.where((item) => !not.contains(item.id)).toList();
    for (var root in roots) {
      if (hasLoop(root, {root.id})) {
        return true;
      }
    }
    return false;
  }

  @override
  void binding(GraphData getData) {
    this.getData = getData;
  }

  @override
  void unbinding() {
    getData = null;
  }

  @override
  Future<bool> update(XTransfer data) async {
    if (getData != null) {
      data.graph = getData!();
    }
    return await super.update(data);
  }

  @override
  Future<HttpResponseType> request(Node node, {KeyValue? env}) async {
    var request = deepClone(node) as Request;
    var json = jsonEncode(request.data);
    for (var match in RegExp(r'/\{\{[^{}]*\}\}/g').allMatches(json)) {
      for (var index = 0; index < match.groupCount; index++) {
        var matcher = match[index]!;
        var varName = matcher.substring(2, matcher.length - 2);
        json = json.replaceAll(matcher, (env![key] == varName) ? varName : '');
      }
    }
    var res = await kernel.httpForward(jsonDecode(json));
    return res.data?.content != null ? jsonDecode(res.data!.content) : res;
  }

  @override
  dynamic running(String code, dynamic args, {KeyValue? env}) {
    var runtime = {
      'environment': env ?? {},
      'preData': args,
      'nextData': {},
      'decrypt': decrypt,
      'encrypt': encrypt,
      'log': (args) {
        print(args);
      },
    };
    // sandbox(code)(runtime);
    return runtime['nextData'];
  }

  @override
  Future<List<dynamic>> writing(Node node, List<dynamic> array) async {
    final write = node as Store;
    if (write.directIs) {
      final applications =
          await directory.target.directory.loadAllApplication();
      for (final app in applications) {
        final works = await app.loadWorks();
        final work = works.firstWhere(
          (item) => item.id == write.workId,
        );
        await work.loadWorkNode();
        if (work.primaryForms.isNotEmpty && work.node != null) {
          final apply = await work.createApply();
          if (apply != null) {
            final map = <String, FormEditData>{};
            final editForm = FormEditData(
              before: [],
              after: [],
              nodeId: work.node?.id,
              creator: apply.belong.userId,
              createTime:
                  DateTime.now().format(format: 'yyyy-MM-dd hh:mm:ss.S'),
            );
            final belongId = directory.belongId;
            for (final item in array) {
              final res = await kernel.createThing(belongId, [], '资产卡片');
              if (res.success) {
                item.data = res.data;
                final one = item;
                editForm.after.add(one);
              }
            }
            map[work.primaryForms[0].id] = editForm;
            await apply.createApply(belongId, '自动写入', map);
          }
        }
      }
    }
    return [];
  }

  @override
  Future<List<dynamic>> mapping(Node node, List<dynamic> array) async {
    final data = node as Mapping;
    final ans = <dynamic>[];
    final form = findMetadata<XForm>(data.source);
    if (form != null) {
      final sourceMap = <String, XAttribute>{};
      form.attributes?.forEach((attr) {
        if (attr.property?.info != null) {
          sourceMap[attr.property!.info!] = attr;
        }
      });
      for (final item in array) {
        final oldItem = <String, dynamic>{};
        final newItem = <String, dynamic>{'Id': command.id};
        item.keys.forEach((key) {
          if (sourceMap.containsKey(key)) {
            final attr = sourceMap[key]!;
            oldItem[attr.id] = item[key];
          }
        });
        for (final mapping in data.mappings) {
          if (oldItem.containsKey(mapping.source)) {
            newItem[mapping.target] = oldItem[mapping.source];
          }
        }
        ans.add(newItem);
      }
    }
    return ans;
  }

  @override
  Future<List<Sheet<T>>> template<T>(Node node) async {
    final tables = node as Tables;
    final List<Sheet<T>> ans = [];
    for (var formId in tables.formIds) {
      var form = getEntity<IForm>(formId);
      if (form != null) {
        await form.loadContent();
        List<Column> columns = [];
        for (var field in form.fields) {
          columns.add(Column(
            title: field.name!,
            dataIndex: field.id!,
            valueType: field.valueType!,
          ));
        }
        ans.add(Sheet(
          name: form.name,
          headers: 1,
          columns: columns,
          data: [],
        ));
      }
    }
    return ans;
  }

  @override
  Future<bool> reading(Node node) async {
    // final table = node as Tables;
    // if (table.file) { }
    return false;
  }

  @override
  Node? getNode(String id) {
    for (final node in metadata.nodes) {
      if (node.id == id) {
        return node;
      }
    }
    return null;
  }

  @override
  Future<void> addNode(Node node) async {
    final index = metadata.nodes.indexWhere((item) => item.id == node.id);
    if (index == -1) {
      metadata.nodes.add(node);
      if (await update(metadata)) {
        command.emitter('node', 'add', [node]);
      }
    }
  }

  @override
  Future<void> updNode(Node node) async {
    final index = metadata.nodes.indexWhere((item) => item.id == node.id);
    if (index != -1) {
      metadata.nodes[index] = node;
      if (await update(metadata)) {
        command.emitter('node', 'update', [node]);
      }
    }
  }

  @override
  Future<void> delNode(String id) async {
    int index = metadata.nodes.indexWhere((item) => item.id == id);
    if (index != -1) {
      Node node = metadata.nodes[index];
      metadata.nodes.removeAt(index);
      if (await update(metadata)) {
        command.emitter('node', 'delete', [node]);
      }
    }
  }

  @override
  Edge? getEdge(String id) {
    for (Edge edge in metadata.edges) {
      if (edge.id == id) {
        return edge;
      }
    }
    return null;
  }

  @override
  Future<bool> addEdge(Edge edge) async {
    int index = metadata.edges.indexWhere((item) => edge.id == item.id);
    if (index == -1) {
      metadata.edges.add(edge);
      if (hasLoop()) {
        metadata.edges.removeLast();
        return false;
      }
      if (await update(metadata)) {
        command.emitter('edge', 'add', [edge]);
      }
    }
    return true;
  }

  @override
  Future<void> updEdge(Edge edge) async {
    int index = metadata.edges.indexWhere((item) => item.id == edge.id);
    if (index != -1) {
      metadata.edges[index] = edge;
      if (await update(metadata)) {
        command.emitter('edge', 'update', [edge]);
      }
    }
  }

  @override
  Future<void> delEdge(String id) async {
    int index = metadata.edges.indexWhere((item) => item.id == id);
    if (index != -1) {
      metadata.edges.removeAt(index);
      if (await update(metadata)) {
        command.emitter('edge', 'delete', [id]);
      }
    }
  }

  @override
  Future<void> addEnv(Environment env) async {
    int index = metadata.envs.indexWhere((item) => item.id == env.id);
    if (index == -1) {
      String id = command.id;
      env.id = id;
      metadata.envs.add(env);
      metadata.curEnv = id;
      if (await update(metadata)) {
        command.emitter('environments', 'refresh', []);
      }
    }
  }

  @override
  Future<void> updEnv(Environment env) async {
    final index = metadata.envs.indexWhere((item) => item.id == env.id);
    if (index != -1) {
      metadata.envs[index] = env;
      if (await update(metadata)) {
        command.emitter('environments', 'refresh', []);
      }
    }
  }

  @override
  Future<void> delEnv(String id) async {
    final index = metadata.envs.indexWhere((item) => item.id == id);
    if (index != -1) {
      metadata.envs.removeAt(index);
      if (await update(metadata)) {
        if (id == metadata.curEnv) {
          metadata.curEnv = null;
        }
        command.emitter('environments', 'refresh', []);
      }
    }
  }

  @override
  Environment? getCurEnv() {
    for (final env in metadata.envs) {
      if (env.id == metadata.curEnv) {
        return env;
      }
    }
    return null;
  }

  @override
  Future<void> changeEnv(String id) async {
    for (final item in metadata.envs) {
      if (item.id == id) {
        metadata.curEnv = id;
        if (await update(metadata)) {
          command.emitter('environments', 'refresh', []);
        }
      }
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

List<Shift<GEvent, GStatus>> machines = [
  Shift(start: GStatus.editable, event: GEvent.editRun, end: GStatus.running),
  Shift(start: GStatus.viewable, event: GEvent.viewRun, end: GStatus.running),
  Shift(
      start: GStatus.running, event: GEvent.completed, end: GStatus.completed),
  Shift(start: GStatus.running, event: GEvent.throw_, end: GStatus.error),
];

/// 任务接口
abstract class ITask {
  /// 触发器
  late Command command;

  /// 迁移配置
  late ITransfer transfer;

  /// 元数据
  late XTask metadata;

  /// 已遍历点（存储数据）
  late Map<String, Map<String, dynamic>> visitedNodes;

  /// 已遍历边
  late Set<String> visitedEdges;

  /// 前置任务
  ITask? preTask;

  /// 启动事件
  late GEvent initEvent;

  /// 启动状态
  late GStatus initStatus;

  /// 开始执行
  Future<void> starting();
}

class Task implements ITask {
  @override
  late Command command;
  @override
  late ITransfer transfer;
  @override
  late XTask metadata;
  @override
  late Map<String, Map<String, dynamic>>
      visitedNodes; //visitedNodes: Map<string, { code: string; data: any }>;
  @override
  late Set<String> visitedEdges;
  @override
  late GEvent initEvent;
  @override
  late GStatus initStatus;
  @override
  late ITask? preTask;

  Task(this.transfer, this.initEvent, this.initStatus, {ITask? task}) {
    metadata = task != null
        ? deepClone(task.metadata)
        : deepClone(
            XTask(
              id: command.id,
              status: initStatus,
              nodes: transfer.metadata.nodes.map((item) {
                item.status = initStatus as NStatus?;
                return item;
              }).toList(),
              env: transfer.getCurEnv(),
              edges: transfer.metadata.edges,
              graph: transfer.metadata.graph,
              startTime: DateTime.now(),
            ),
          );
    visitedNodes = {};
    visitedEdges = {};
    preTask = task;
    command = transfer.command;
  }

  @override
  Future<void> starting() async {
    machine(initEvent);
    refreshEnvs();
    refreshTasks();
    await iterateRoots();
  }

  void refreshEnvs() {
    command.emitter('environments', 'refresh', []);
  }

  void refreshTasks() {
    command.emitter('tasks', 'refresh', []);
  }

  void machine(GEvent event) {
    if (metadata.status.label == 'Error') {
      return;
    }
    for (var shift in machines) {
      if (shift.start == metadata.status && event == shift.event) {
        metadata.status = shift.end;
        command.emitter('graph', 'status', [metadata.status.label]);
      }
    }
  }

  void dataCheck([dynamic preData]) {
    if (preData != null) {
      if (preData is Error) {
        throw preData;
      }
      for (var key in preData.keys) {
        var data = preData[key];
        if (data is Error) {
          throw data;
        }
      }
    }
  }

  Future<void> visitNode(Node node, [dynamic preData]) async {
    node.status = NStatus.running;
    command.emitter('running', 'start', [node]);
    dynamic nextData;
    try {
      dataCheck(preData);
      sleep(const Duration(microseconds: 500));
      var env = metadata.env?.params;
      if (node.preScripts != null) {
        preData = transfer.running(node.preScripts!, preData, env: env);
      }

      bool isArray(dynamic obj) {
        if (obj is List) {
          return true;
        }
        throw Exception('输入必须是一个数组！');
      }

      switch (node.typeName) {
        case '请求':
          nextData = await transfer.request(node, env: env);
          break;
        case '子图':
          {
            // TODO 替换其它方案
            var nextId = (node as SubTransfer).nextId;
            transfer.getTransfer(nextId)?.execute(initStatus, initEvent);
          }
          break;
        case '映射':
          isArray(preData.array);
          nextData = await transfer.mapping(node, preData.array);
          break;
        case '存储':
          isArray(preData);
          await transfer.writing(node, preData);
          nextData = preData;
          break;
        case '表格':
          await transfer.reading(node);
          break;
      }
      if (node.postScripts != null) {
        nextData = transfer.running(node.postScripts!, nextData, env: env);
      }
      visitedNodes[node.id] = {'code': node.code, 'data': nextData};
      node.status = NStatus.completed;
      command.emitter('running', 'completed', [node]);
    } catch (error) {
      visitedNodes[node.id] = {'code': node.code, 'data': error};
      machine(GEvent.throw_);
      node.status = NStatus.error;
      command.emitter('running', 'error', [node, error]);
    }
    refreshEnvs();
    if (await tryRunning(nextData: nextData)) {
      await next(node);
    }
  }

  Map<String, dynamic> preCheck(Node node) {
    var data = {};
    for (var edge in metadata.edges) {
      if (node.id == edge.end) {
        if (!visitedEdges.contains(edge.id)) {
          return {'s': false, 'd': {}};
        }
        if (visitedNodes.containsKey(edge.start)) {
          var nodeData = visitedNodes[edge.start]!;
          data[nodeData['code']] = nodeData['data'];
        }
      }
    }
    if (data.length == 1) {
      return {'s': true, 'd': data[data.keys.first]};
    }
    return {'s': true, 'd': data};
  }

  Future<void> iterateRoots() async {
    if (await tryRunning()) {
      final not = metadata.edges.map((item) => item.end);
      final roots = metadata.nodes.where((item) => !not.contains(item.id));
      await Future.wait(roots.map((root) => visitNode(root)));
    }
  }

  Future<void> next(Node preNode) async {
    for (final edge in metadata.edges) {
      if (preNode.id == edge.start) {
        visitedEdges.add(edge.id);
        for (final node in metadata.nodes) {
          if (node.id == edge.end) {
            final next = preCheck(node);
            if (next['s']) {
              await visitNode(node, next["d"]);
            }
          }
        }
      }
    }
  }

  Future<bool> tryRunning({dynamic nextData}) async {
    if (visitedNodes.length == metadata.nodes.length) {
      metadata.endTime = DateTime.now();
      machine(GEvent.completed);
      refreshTasks();
      if (initStatus == GStatus.editable) {
        command.emitter('graph', 'status', [GStatus.editable.label]);
      } else if (initStatus == GStatus.viewable) {
        command.emitter('graph', 'status', [GStatus.viewable.label]);
      }
      await selfCircle(nextData: nextData);
      return false;
    }
    return true;
  }

  Future<void> selfCircle({dynamic nextData}) async {
    if (transfer.metadata.isSelfCirculation) {
      final judge = transfer.metadata.judge;
      if (judge.isNotEmpty) {
        final params = metadata.env?.params;
        final res = transfer.running(judge, nextData, env: params);
        if (res.success) {
          await transfer.nextExecute(this);
        }
      }
    }
  }
}

Tables getDefaultTableNode() {
  return Tables(
    id: command.id,
    code: 'table',
    name: '表格',
    typeName: '表格',
    formIds: [],
  );
}

Request getDefaultRequestNode() {
  return Request(
    id: command.id,
    code: 'request',
    name: '请求',
    typeName: '请求',
    data: HttpRequestType(
      uri: '',
      method: 'GET',
      header: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
      content: '',
    ),
  );
}

Mapping getDefaultMappingNode() {
  return Mapping(
    id: command.id,
    code: 'mapping',
    name: '映射',
    typeName: '映射',
    source: '',
    target: '',
    mappings: [],
  );
}

Store getDefaultStoreNode() {
  return Store(
    id: command.id,
    code: 'store',
    name: '存储',
    typeName: '存储',
    directoryId: '',
    workId: '',
    formIds: [],
    directIs: false,
  );
}

SubTransfer getDefaultTransferNode() {
  return SubTransfer(
    id: command.id,
    code: 'transfer',
    name: '子图',
    typeName: '子图',
    nextId: '',
  );
}
