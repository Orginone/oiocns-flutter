import 'dart:ui';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/pages/other/work/initiate_work/state.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/toast_utils.dart';

class WorkNetWork {
  static Future<List<XFlowTask>> getApproveTask({required String type}) async {
    List<XFlowTask> tasks = [];

    SettingController setting = Get.find<SettingController>();

    ResultType<XFlowTaskArray> result = await KernelApi.getInstance()
        .queryApproveTask(IdReq(id: setting.space.id));

    if (result.success) {
      tasks = result.data?.result ?? [];
      if(type == "待办"){
        type = "审批";
      }
      tasks.removeWhere((element) => element.flowNode?.nodeType != type);
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return tasks;
  }

  static Future<List<XFlowTaskHistory>> getRecord(List<int> status) async {
    List<XFlowTaskHistory> tasks = [];

    SettingController setting = Get.find<SettingController>();

    ResultType<XFlowTaskHistoryArray> result = await KernelApi.getInstance()
        .queryRecord(RecordSpaceReq(
            spaceId: setting.space.id,
            page: PageRequest(offset: 0, limit: 9999, filter: ''), status: status));

    if (result.success) {
      tasks = result.data?.result ?? [];
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return tasks;
  }

  static Future<XFlowInstance?> getFlowInstance(String id) async {
    XFlowInstance? flowInstance;
    ResultType<XFlowInstance> result = await KernelApi.getInstance()
        .queryInstanceById(IdReq(
        id: id));

    if (result.success) {
      flowInstance = result.data;
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return flowInstance;
  }

  static Future<List<XOperationItem>> getOperationItems(String id) async {
    List<XOperationItem> items = [];
    SettingController setting = Get.find<SettingController>();
    ResultType<XOperationItemArray> result = await KernelApi.getInstance()
        .queryOperationItems(IdSpaceReq(id: id,spaceId: setting.space.id, page: PageRequest(offset: 0, limit: 9999, filter: '')));

    if (result.success) {
      items = result.data?.result??[];
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return items;
  }

  static Future<void> approvalTask(
      {required String id, required int status, String? comment,VoidCallback? onSuccess}) async {
    ResultType req = await KernelApi.getInstance().approvalTask(
        ApprovalTaskReq(id: id, status: status, comment: comment));

    if (req.success) {
      ToastUtils.showMsg(msg: "成功");
      EventBusHelper.fire(WorkReload());
      if (onSuccess != null) {
        onSuccess();
      }
    } else {
      ToastUtils.showMsg(msg: req.msg);
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
            name: value.teamName, children: []);
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
         );
      await WorkNetWork.initSpecies(child);
      model.children.add(child);
    }
  }

  static Future<void> initSpecies(WorkBreadcrumbNav model) async{
    List<ISpeciesItem>? species = await model.space?.loadSpeciesTree();
    void loopSpeciesTree(List<ISpeciesItem> tree,WorkBreadcrumbNav model){
      for (var element in tree) {
        var child = WorkBreadcrumbNav(
            space: model.space,
            source: element,
            name: element.name, children: []);
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
