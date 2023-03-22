import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
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
      Get.back();
    }else{
      ToastUtils.showMsg(msg: result.msg);
    }
  }
}
