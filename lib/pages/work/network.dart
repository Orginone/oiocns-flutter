import 'dart:ui';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/out_team/group.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';
import 'package:orginone/util/toast_utils.dart';


SettingController setting = Get.find<SettingController>();

class WorkNetWork {

  static Future<List<XWorkTask>> getTodo() async {

    var result = await setting.provider.work?.loadTodos(reload: true);
    return result??[];
  }

  static Future<XWorkInstance?> getFlowInstance(XWorkTask todo) async {
    XWorkInstance? flowInstance = await setting.provider.work?.loadTaskDetail(todo);
    return flowInstance;
  }

  static Future<IWorkDefine?> getFlowDefine(XWorkTask todo) async {
    IWorkDefine? define = await setting.provider.work?.findFlowDefine(todo.defineId!);
    return define;
  }


  static Future<void> approvalTask(
      {required XWorkTask todo, required int status, String? comment,VoidCallback? onSuccess}) async {

    bool success = await setting.provider.work!.approvalTask([todo],status,comment: comment);
    if (success) {
      ToastUtils.showMsg(msg: "成功");
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }

  static Future<void> initGroup(WorkBreadcrumbNav model) async {
    Future<void> getNextLvOutAgency(
        List<IGroup> group, WorkBreadcrumbNav model) async {
      for (var value in group) {
        var child = WorkBreadcrumbNav(
            space: model.space,
            source: value,
            image: value.metadata.avatarThumbnail(),
            name: value.metadata.name, children: [],workType: WorkType.group);
        value.children = await value.loadChildren();
        if (value.children.isNotEmpty) {
          await getNextLvOutAgency(value.children, child);
        }else{
          await WorkNetWork.initSpecies(child);
        }
        model.children.add(child);
      }
    }

    var group = await (model.space as ICompany).loadGroups();
    await getNextLvOutAgency(group, model);
  }

  static Future<void> initCohorts(WorkBreadcrumbNav model) async {
    var cohorts = await model.space!.loadCohorts();
    for (var value in cohorts) {
      var child = WorkBreadcrumbNav(
          space: model.space,
          source: value,
          image: value.metadata.avatarThumbnail(),
          name: value.metadata.name??"", children: [],
          workType: WorkType.group
         );
      await WorkNetWork.initSpecies(child);
      model.children.add(child);
    }
  }

  static Future<void> initSpecies(WorkBreadcrumbNav model) async{
    if(model.children.where((element) => element.source?.target?.code == 'matters').isNotEmpty){
      return;
    }
    List<ISpeciesItem>? species = await model.space?.loadSpecies();
    void loopSpeciesTree(List<ISpeciesItem> tree,WorkBreadcrumbNav model){
      for (var element in tree) {
        var child = WorkBreadcrumbNav(
            space: model.space,
            source: element,
            name: element.metadata.name, children: [],workType: WorkType.group);
        if(element.children.isNotEmpty){
          loopSpeciesTree(element.children,child);
        }
        model.children.add(child);
      }
    }
    if(species!=null){
      loopSpeciesTree(species.where((element) => element.metadata.code == 'matters').toList(),model);
    }
  }
}
