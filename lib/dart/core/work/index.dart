import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/main.dart';

abstract class IWork {
  IApplication? application;
  late List<IFormView> forms;
  late XWorkDefine metadata;

  // 更新办事定义的实现
  Future<bool> updateDefine(WorkDefineModel data);

  Future<WorkNodeModel?> loadWorkNode();

  Future<List<IFormView>> loadWorkForms();

  Future<bool> deleteDefine();

  Future<XWorkInstance?> createWorkInstance(WorkInstanceModel data);
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

class Work implements IWork {

  Work(XWorkDefine metadata,this.application){
    this.metadata = fullDefineRule(metadata);
    forms = [];
  }


  @override
  IApplication? application;

  @override
  late List<IFormView> forms;

  @override
  late XWorkDefine metadata;

  @override
  Future<XWorkInstance?> createWorkInstance(WorkInstanceModel data) async{
    var res = await kernel.createWorkInstance(data);
    if (res.success) {
      return res.data;
    }
    return null;
  }

  @override
  Future<bool> deleteDefine() async{
     if(application!=null){
       var res = await kernel.deleteWorkDefine(IdReq(id: metadata.id!));
       if (res.success) {
         application?.works.removeWhere((a) => a.metadata.id != metadata.id);
       }
       return res.success;
     }
     return false;
  }

  @override
  Future<List<IFormView>> loadWorkForms() async {
    List<IFormView> forms = [];
    var res = await kernel.queryWorkNodes(IdReq(id: metadata.id!));
    if (res.success && res.data != null) {
      void recursionForms(WorkNodeModel node) {
        if (node.forms != null && node.forms!.isNotEmpty) {
          forms.addAll(node.forms!.map((i) => FormView(i)));
        }
        if (node.children != null) {
          recursionForms(node.children!);
        }
        if (node.branches != null) {
          for (var branch in node.branches!) {
            if (branch.children != null) {
              recursionForms(branch.children!);
            }
          }
        }
      }
      recursionForms(res.data!);
    }
    this.forms = forms;
    return forms;
  }

  @override
  Future<WorkNodeModel?> loadWorkNode() async{
    var res = await kernel.queryWorkNodes(IdReq(id: metadata.id!));
    if (res.success) {
      return res.data;
    }
    return null;
  }

  @override
  Future<bool> updateDefine(WorkDefineModel data) async{
    data.id = metadata.id!;
    data.applicationId = metadata.applicationId;
    var res = await kernel.createWorkDefine(data);
    return res.success;
  }

}