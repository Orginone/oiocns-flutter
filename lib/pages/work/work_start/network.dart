import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/toast_utils.dart';

class WorkStartNetWork {
  static Future<List<XWorkDefine>> getWorkDefine(String speciesId) async {
    List<XWorkDefine> defines = [];
    // ResultType<XWorkDefineArray> result = await KernelApi.getInstance()
    //     .queryWorkDefine(GetSpeciesResourceModel(
    //         speciesId: speciesId,
    //         spaceId: '0',
    //         page: PageRequest(offset: 0, limit: 20, filter: '')));
    // if (result.success) {
    //   defines = result.data?.result ?? [];
    // }
    return defines;
  }

  static Future<WorkNodeModel?> getDefineNode(String id) async {
    WorkNodeModel? node;
    var settingCtrl = Get.find<SettingController>();
    // var space = settingCtrl.space;
    ResultType<WorkNodeModel> result = await KernelApi.getInstance().queryWorkNodes(
        IdReq(
            id: id,
        ));
    node = result.data;
    return node;
  }

  static Future<void> createInstance(IWorkDefine define,
      Map<String, dynamic> data, List<String> thingIds) async {
    XWorkInstance? result = await define.createWorkInstance(
      WorkInstanceModel(
        defineId: define.metadata.id!,
        content: "",
        contentType: "Text",
        data: jsonEncode(data),
        title: define.metadata.name!,
        thingIds: thingIds,
        hook: "",
      ),
    );

    if (result!=null) {
      ToastUtils.showMsg(msg: "提交成功");
      EventBusHelper.fire(WorkReload());
      Get.back();
    }
  }

  static Future<List<XWorkInstance>> getWorkInstance({String? id,String? speciesId}) async {
    List<XWorkInstance> WorkInstacnes = [];
    SettingController setting = Get.find<SettingController>();
    ResultType<XWorkInstanceArray> result = await KernelApi.getInstance()
        .queryInstanceByApply(FlowReq(
        id: id,spaceId: '0',speciesId: speciesId, page: PageRequest(offset: 0, limit: 9999, filter: '')));

    if (result.success) {
      WorkInstacnes = result.data?.result??[];
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return WorkInstacnes;
  }
}
