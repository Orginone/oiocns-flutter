import 'dart:convert';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/dart/core/work/apply.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/main.dart';

abstract class IWorkTask {
  //唯一标识
  late String id;
  //内容
  late String content;
  //当前用户
  late UserProvider user;
  //归属空间
  late IBelong belong;
  //任务元数据
  late XWorkTask metadata;
  //流程实例
  XWorkInstance? instance;
  //实例携带的数据
  InstanceDataModel? instanceData;
  //加用户任务信息
  late List<XTarget> targets;
  //是否满足条件
  bool isMatch(String filter);
  //任务更新
  Future<bool> updated(XWorkTask metadata);
  //加载流程实例数据
  Future<bool> loadInstance({bool reload = false});
  //撤回任务
  Future<bool> recallApply();
  //创建申请
  Future<IWorkApply?> createApply();
  //任务审批
  Future<bool> approvalTask(int status, {String? comment});
}

class WorkTask implements IWorkTask {
  WorkTask(this.metadata, this.user);

  @override
  late XWorkTask metadata;

  @override
  late UserProvider user;
  @override
  XWorkInstance? instance;

  @override
  InstanceDataModel? instanceData;

  @override
  String get id => metadata.id;

  @override
  String get content {
    if (targets.length == 2) {
      return '${targets[0].name}[${targets[0].typeName}]申请加入${targets[1].name}[${targets[1].typeName}]';
    }
    return metadata.content ?? '';
  }

  @override
  IBelong get belong {
    for (final company in user.user!.companys) {
      if (company.id == metadata.belongId) {
        return company;
      }
    }
    return user.user!;
  }

  @override
  List<XTarget> get targets {
    if (metadata.taskType == '加用户') {
      try {
        final parsedContent =
            jsonDecode(metadata.content ?? "[]") as List<dynamic>;
        return parsedContent.map((item) => XTarget.fromJson(item)).toList();
      } catch (ex) {
        return [];
      }
    }
    return [];
  }

  @override
  bool isMatch(String filter) {
    return jsonEncode(metadata.toJson()).contains(filter);
  }

  @override
  Future<bool> updated(XWorkTask metadata) async {
    if (this.metadata.id == metadata.id) {
      this.metadata = metadata;
      await loadInstance(reload: true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> loadInstance({bool reload = false}) async {
    if (instanceData != null && !reload) return true;
    var res = await kernel.collectionAggregate(
      metadata.belongId!,
      [metadata.belongId!],
      storeCollName['workInstance']!,
      {
        "match": {
          "id": metadata.instanceId,
        },
        "limit": 1,
        "lookup": {
          "from": storeCollName['workTask']!,
          "localField": 'id',
          "foreignField": 'instanceId',
          "as": 'tasks',
        },
      },
    );

    if (res.data != null && res.data.length > 0) {
      try {
        instance = XWorkInstance.fromJson(res.data[0]);
        Map<String, dynamic> json = jsonDecode(instance!.data ?? "");
        instanceData = instance != null && json.isNotEmpty
            ? InstanceDataModel.fromJson(jsonDecode(instance!.data ?? ""))
            : null;
        return instanceData != null;
      } catch (ex) {
        print(ex);
      }
    }
    return false;
  }

  @override
  Future<bool> recallApply() async {
    if (await loadInstance() && instance != null) {
      if (instance?.createUser == belong.userId) {
        if ((await kernel.recallWorkInstance(IdModel(instance!.id))).success) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<bool> approvalTask(int status, {String? comment}) async {
    if ((metadata.status!) < TaskStatus.approvalStart.status) {
      if (status == -1) {
        return await recallApply();
      }
      if (metadata.taskType == '加用户' || await loadInstance(reload: true)) {
        final res = await kernel.approvalTask(ApprovalTaskReq(
          id: metadata.id,
          status: status,
          comment: comment,
          data: instanceData != null
              ? jsonEncode(instanceData?.toJson() ?? {})
              : null,
        ));
        if (res.success && status < TaskStatus.refuseStart.status) {
          if (targets.length == 2) {
            for (final item in user.targets) {
              if (item.id == targets[1].id) {
                item.pullMembers([targets[0]]);
              }
            }
          }
        }
        return res.success;
      }
    }
    return false;
  }

  @override
  Future<IWorkApply?> createApply() async {
    if (metadata.approveType == '子流程') {
      var define = await findWorkById(metadata.defineId ?? '');
      if (define != null && (await define.loadWorkNode() != null)) {
        final data = InstanceDataModel(
          data: instanceData?.data,
          fields: {},
          primary: {},
          node: define.node!,
          allowAdd: define.metadata.allowAdd,
          allowEdit: define.metadata.allowEdit,
          allowSelect: define.metadata.allowSelect,
        );
        for (var form in define.primaryForms) {
          data.fields![form.id] = form.fields;
        }
        return WorkApply(
          WorkInstanceModel(
            hook: '',
            taskId: id,
            title: define.name,
            defineId: define.id,
            applyId: instance!.shareId,
          ),
          data,
          define.application.directory.target.space!,
          [...define.primaryForms, ...define.detailForms],
        );
      }
    }
    return null;
  }

  Future<IWork?> findWorkById(String wrokId) async {
    for (var target in user.targets) {
      for (var app in await target.directory.loadAllApplication()) {
        final works = await app.loadWorks();
        final indx = works.indexWhere((a) => a.metadata.id == wrokId);
        final work = works.firstWhere((a) => a.metadata.id == wrokId);
        if (indx < 0) {
          return work;
        }
      }
    }
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
