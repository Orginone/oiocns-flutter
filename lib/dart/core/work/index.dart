import 'dart:convert';

import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/main.dart';

import 'apply.dart';

abstract class IWork extends IFileInfo<XWorkDefine> {
  late IApplication application;
  late List<IForm> forms;

  WorkNodeModel? node;

  // 更新办事定义的实现
  Future<bool> update(WorkDefineModel req);

  Future<WorkNodeModel?> loadWorkNode({bool reload = false});

  Future<List<IForm>> loadWorkForms({bool reload = false});

  Future<IWorkApply?> createApply();
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
    XWorkDefine metadata,
    this.application,
  ) : super(fullDefineRule(metadata), application.directory) {
    forms = [];
  }

  @override
  late IApplication application;

  @override
  late List<IForm> forms;

  @override
  bool isLoaded = false;

  @override
  WorkNodeModel? node;

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
  Future<IWorkApply?> createApply() async{
    if (node != null && forms.isNotEmpty) {
      final InstanceDataModel data = InstanceDataModel(
        node: node!,
        allowAdd: metadata.allowAdd,
        allowEdit: metadata.allowEdit,
        allowSelect: metadata.allowSelect,
      );
      return WorkApply(
        directory.target.space,
        WorkInstanceModel(
          hook: '',
          taskId: '0',
          title: metadata.name,
          defineId: id,
        ),
        data,
      );
    }
    return null;
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteWorkDefine(IdReq(id: id));
    if (res.success) {
      application.works.removeWhere((a) => a.id == id);
    }
    return res.success;
  }

  @override
  Future<List<IForm>> loadWorkForms({bool reload = false}) async{
    final List<IForm> forms = [];
    if (!reload) {
      await loadWorkNode(reload: true);
    }
    if (node != null) {
      recursionForms(WorkNodeModel node) async {
        for (var item in node.forms??[]) {
          final form = Form(
            item..id = "${item.id!}",
            directory,
          );
          await form.loadContent();
          forms.add(form);
        }
        if (node.children != null) {
          await recursionForms(node.children!);
        }
        if (node.branches != null) {
          for (final branch in node.branches!) {
            if (branch.children != null) {
              await recursionForms(branch.children!);
            }
          }
        }
      }
      await recursionForms(node!);
    }
    this.forms = forms;
    return forms;
  }

  @override
  Future<WorkNodeModel?> loadWorkNode({bool reload = false}) async{
    if (node == null || reload) {
      final res = await kernel.queryWorkNodes(IdReq(id: id));
      if (res.success) {
        node = res.data;
      }
    }
    return node;
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
          directory.propertys.removeWhere((i) => i.id == destination.id);
          application = app;
          app.works.add(this);
        }
        return success;
      }
    }
    return false;
  }

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem => [];

  @override
  Future<bool> rename(String name) async {
    final node = await loadWorkNode();
    var data = WorkDefineModel.fromJson(metadata.toJson());
    data.name = name;
    data.resource = node;
    return await update(data);
  }

  @override
  Future<bool> update(WorkDefineModel req) async{
    req.id = id;
    req.applicationId = metadata.applicationId;
    var res = await kernel.createWorkDefine(req);
    if (res.success && res.data!=null) {
      node = req.resource;
    }
    return res.success;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await loadWorkForms();
    return forms.isNotEmpty;
  }

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    return forms;
  }

  @override
  // TODO: implement locationKey
  String get locationKey => application.locationKey;
}