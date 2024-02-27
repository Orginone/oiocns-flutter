import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/thing/standard/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/main_base.dart';

import 'apply.dart';

abstract class IWork extends IFileInfo<XWorkDefine> {
  /// 主表
  List<IForm> primaryForms = [];

  ///子表
  List<IForm> detailForms = [];

  ///应用
  late IApplication application;

  ///流程节点
  WorkNodeModel? node;

  // 更新办事定义的实现
  Future<bool> update(WorkDefineModel req);

  ///加载事项定义节点
  Future<WorkNodeModel?> loadWorkNode({bool reload = false});

  ///生成办事申请单
  Future<IWorkApply?> createApply();

  /// 接收通知
  bool receive(String operate, XWorkDefine data);
}

XWorkDefine fullDefineRule(XWorkDefine data) {
  data.allowAdd = true;
  data.allowEdit = true;
  data.allowSelect = true;
  if (data.rule != null &&
      data.rule!.contains('{') &&
      data.rule!.contains('}')) {
    Map<String, dynamic> rule = json.decode(data.rule!);
    data.allowAdd = rule['allowAdd'];
    data.allowEdit = rule['allowEdit'];
    data.allowSelect = rule['allowSelect'];
  }
  data.typeName = '事项';
  return data;
}

class Work extends FileInfo<XWorkDefine> implements IWork {
  Work(
    this.metadata,
    this.application,
  ) : super(fullDefineRule(metadata), application.directory) {
    isContainer = application.isInherited;
  }

  @override
  final XWorkDefine metadata;
  @override
  final IApplication application;

  @override
  bool isLoaded = false;

  @override
  WorkNodeModel? node;

  @override
  String get locationKey => application.locationKey;
  @override
  String get cacheFlag => 'works';
  List<IForm> get forms => [...primaryForms, ...detailForms];

  @override
  List<String> get groupTags {
    var tags = target.space?.name == null ? [] : [target.space?.name];
    if (target.id != target.spaceId) {
      tags.add(target.name);
    }
    return [...tags, ...super.groupTags];
  }

  @override
  Future<bool> delete({bool? notity}) async {
    final res = await kernel.deleteWorkDefine(IdModel(id));
    if (res.success) {
      application.works.removeWhere((a) => a.id == id);
    }
    return res.success;
  }

  @override
  Future<bool> rename(String name) async {
    final node = await loadWorkNode();
    var data = WorkDefineModel.fromJson(metadata.toJson());
    data.name = name;
    data.resource = node;
    return await update(data);
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != application.id) {
      if (destination is IApplication) {
        final app = destination as IApplication;
        final node = await loadWorkNode();

        var data = WorkDefineModel.fromJson(metadata.toJson());
        data.applicationId = app.id;
        data.resource = node;
        final res = await app.createWork(data);
        return res != null;
      }
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (destination.id != directory.id &&
        destination.metadata.belongId == application.metadata.belongId) {
      if (destination is IApplication) {
        final app = destination as IApplication;
        final node = await loadWorkNode();
        var data = WorkDefineModel.fromJson(metadata.toJson());
        data.resource = node;
        final success = await update(data);
        if (success) {
          directory.standard.propertys
              .removeWhere((i) => i.id == destination.id);
          application = app;
          app.works.add(this);
        }
        return success;
      }
    }
    return false;
  }

  @override
  List<IFileInfo<XEntity>> content({bool? args}) {
    if (node != null) {
      return forms
          .where(
            (a) => node!.forms!.indexWhere((s) => s.id == a.id) > -1,
          )
          .toList()
          .map((e) => e)
          .toList();
    }
    return [];
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await loadWorkNode();
    return forms.isNotEmpty;
  }

  @override
  Future<bool> update(WorkDefineModel data) async {
    data.id = id;
    data.applicationId = metadata.applicationId;
    var res = await kernel.createWorkDefine(data);
    if (res.success && res.data != null) {
      node = data.resource;
      await recursionForms(node!);
    }
    return res.success;
  }

  @override
  Future<WorkNodeModel?> loadWorkNode({bool reload = false}) async {
    if (node == null || reload) {
      final res = await kernel.queryWorkNodes(IdReq(id: id));
      if (res.success) {
        node = res.data;
        await recursionForms(node!);
      }
    }
    return node;
  }

  @override
  Future<IWorkApply?> createApply() async {
    await loadWorkNode();
    if (node != null && forms.isNotEmpty) {
      final InstanceDataModel data = InstanceDataModel(
        node: node!,
        allowAdd: metadata.allowAdd,
        allowEdit: metadata.allowEdit,
        allowSelect: metadata.allowSelect,
      );
      await Future.wait(
        forms.map((form) async {
          await form.loadContent();
          data.fields?[form.id] = form.fields;
        }).toList(),
      );
      return WorkApply(
        WorkInstanceModel(
          hook: '',
          taskId: '0',
          title: metadata.name,
          defineId: id,
        ),
        data,
        directory.target.space!,
        forms,
      );
    }
    return null;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    return super
        .operates(mode: mode)
        .where(
          (a) => ![FileOperates.copy, FileOperates.move, FileOperates.download]
              .contains(a),
        )
        .toList();
  }

  recursionForms(WorkNodeModel node) async {
    // node.detailForms = await directory.resource.formColl.where(
    //   node.forms?.where((a) => a.typeName == '子表').toList().map((s) => s.id),
    // );
    // node.primaryForms = await directory.resource.formColl.where(
    //   node.forms?.where((a) => a.typeName == '主表').toList().map((s) => s.id),
    // );
    node.primaryForms?.forEach((a) async {
      a.id = '${a.id}_';
      final form = Form(a, directory);
      primaryForms.add(form);
      await form.loadFields();
    });
    node.detailForms?.forEach((a) async {
      a.id = '${a.id}_';
      final form = Form(a, directory);
      detailForms.add(form);
      await form.loadFields();
    });
    if (node.children != null) {
      await recursionForms(node.children!);
    }
    if (node.branches != null) {
      for (var branch in node.branches!) {
        if (branch.children != null) {
          recursionForms(branch.children!);
        }
      }
    }
  }

  @override
  bool receive(String operate, XWorkDefine data) {
    if (operate == 'workReplace' && data.id == id) {
      setMetadata(fullDefineRule(data));
      loadContent(reload: true).then((value) => changCallback());
    }
    return true;
  }

  @override
  List<IForm> detailForms = [];

  @override
  List<IForm> primaryForms = [];

  @override
  set application(IApplication application) {
    // TODO: implement application
  }

  @override
  set belongId(String belongId) {
    // TODO: implement belongId
  }

  @override
  set cacheFlag(String cacheFlag) {
    // TODO: implement cacheFlag
  }

  @override
  set isContainer(bool isContainer) {
    // TODO: implement isContainer
  }

  @override
  set isInherited(bool isInherited) {
    // TODO: implement isInherited
  }

  @override
  set locationKey(String locationKey) {
    // TODO: implement locationKey
  }

  @override
  set spaceId(String spaceId) {
    // TODO: implement spaceId
  }

  @override
  set superior(IFileInfo<XEntity> superior) {
    // TODO: implement superior
  }
}
