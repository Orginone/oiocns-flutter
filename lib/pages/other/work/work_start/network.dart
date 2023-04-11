import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/toast_utils.dart';

class WorkStartNetWork {
  static Future<List<XFlowDefine>> getFlowDefine(String speciesId) async {
    List<XFlowDefine> defines = [];
    var settingCtrl = Get.find<SettingController>();
    var space = settingCtrl.space;
    ResultType<XFlowDefineArray> result = await KernelApi.getInstance()
        .queryDefine(QueryDefineReq(
            speciesId: speciesId,
            spaceId: space.id,
            page: PageRequest(offset: 0, limit: 20, filter: '')));
    if (result.success) {
      defines = result.data?.result ?? [];
    }
    return defines;
  }

  static Future<FlowNode?> getDefineNode(String id) async {
    FlowNode? node;
    var settingCtrl = Get.find<SettingController>();
    var space = settingCtrl.space;
    ResultType<FlowNode> result = await KernelApi.getInstance().queryNodes(
        IdSpaceReq(
            id: id,
            spaceId: space.id,
            page: PageRequest(offset: 0, limit: 20, filter: '')));
    node = result.data;
    return node;
  }

  static Future<void> createInstance(XFlowDefine define,
      Map<String, dynamic> data, List<String> thingIds) async {
    var settingCtrl = Get.find<SettingController>();
    var space = settingCtrl.space;
    ResultType result = await KernelApi.getInstance().createInstance(
      FlowInstanceModel(
        defineId: define.id!,
        spaceId: space.id,
        content: "",
        contentType: "Text",
        data: jsonEncode(data),
        title: define.name!,
        thingIds: thingIds,
        hook: "",
      ),
    );
    if (result.success) {
      ToastUtils.showMsg(msg: "提交成功");
      EventBusHelper.fire(WorkReload());
      Get.back();
    }else{
      ToastUtils.showMsg(msg: result.msg);
    }
  }

  static Future<List<XFlowInstance>> getFlowInstance({String? id,String? speciesId}) async {
    List<XFlowInstance> flowInstacnes = [];
    SettingController setting = Get.find<SettingController>();
    ResultType<XFlowInstanceArray> result = await KernelApi.getInstance()
        .queryInstanceByApply(FlowReq(
        id: id,spaceId: setting.space.id,speciesId: speciesId, page: PageRequest(offset: 0, limit: 9999, filter: '')));

    if (result.success) {
      flowInstacnes = result.data?.result??[];
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return flowInstacnes;
  }
}
