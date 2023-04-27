import 'dart:ui';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/target/todo/todo.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/toast_utils.dart';


SettingController setting = Get.find<SettingController>();

class WorkNetWork {

  static Future<List<ITodo>> getTodo() async {

    var result = await setting.user.work.loadTodo(reload: true);
    return result;
  }

  static Future<XFlowInstance?> getFlowInstance(String id) async {
    XFlowInstance? flowInstance;
    ResultType<XFlowInstance> result = await KernelApi.getInstance()
        .queryInstanceById(IdReq(
        id: id));

    if (result.success) {
      flowInstance = result.data;
    }
    return flowInstance;
  }

  static Future<List<XOperationItem>> getOperationItems(String id,String spaceId) async {
    List<XOperationItem> items = [];

    ResultType<XOperationItemArray> result = await KernelApi.getInstance()
        .queryOperationItems(IdSpaceReq(id: id,spaceId: spaceId, page: PageRequest(offset: 0, limit: 9999, filter: '')));

    if (result.success) {
      items = result.data?.result??[];
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return items;
  }

  static Future<void> approvalTask(
      {required ITodo todo, required int status, String? comment,VoidCallback? onSuccess}) async {

    bool success = await setting.user.work.approval(todo, status, comment??"",null);
    if (success) {
      ToastUtils.showMsg(msg: "成功");
      EventBusHelper.fire(WorkReload());
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
            image: value.target.avatarThumbnail(),
            name: value.teamName, children: [],workType: WorkType.group);
        value.subGroup = await value.getSubGroups();
        if (value.subTeam.isNotEmpty) {
          await getNextLvOutAgency(value.subGroup, child);
        }else{
          await WorkNetWork.initSpecies(child);
        }
        model.children.add(child);
      }
    }

    var group = await (model.space as ICompany).getJoinedGroups();
    await getNextLvOutAgency(group, model);
  }

  static Future<void> initCohorts(WorkBreadcrumbNav model) async {
    var cohorts = await model.space!.getCohorts();
    for (var value in cohorts) {
      var child = WorkBreadcrumbNav(
          space: model.space,
          source: value,
          image: value.target.avatarThumbnail(),
          name: value.teamName, children: [],
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
    List<ISpeciesItem>? species = await model.space?.loadSpeciesTree();
    void loopSpeciesTree(List<ISpeciesItem> tree,WorkBreadcrumbNav model){
      for (var element in tree) {
        var child = WorkBreadcrumbNav(
            space: model.space,
            source: element,
            name: element.name, children: [],workType: WorkType.group);
        if(element.children.isNotEmpty){
          loopSpeciesTree(element.children,child);
        }
        model.children.add(child);
      }
    }
    if(species!=null){
      loopSpeciesTree(species.where((element) => element.target.code == 'matters').toList(),model);
    }
  }
}
