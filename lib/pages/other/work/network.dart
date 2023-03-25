import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/event/work_reload.dart';
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
      tasks.removeWhere((element) => element.flowNode?.nodeType != type);
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return tasks;
  }

  static Future<List<XFlowTaskHistory>> getRecord() async {
    List<XFlowTaskHistory> tasks = [];

    SettingController setting = Get.find<SettingController>();

    await KernelApi.getInstance()
        .queryNoticeTask(IdReq(
        id: '366950230895235072'));

    ResultType<XFlowTaskHistoryArray> result = await KernelApi.getInstance()
        .queryRecord(IdSpaceReq(
            spaceId: setting.space.id,
            page: PageRequest(offset: 0, limit: 9999, filter: ''), id: '366950230895235072'));

    if (result.success) {
      tasks = result.data?.result ?? [];
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return tasks;
  }

  static Future<XFlowInstance?> getFlowInstance({String? id,String? speciesId}) async {
    XFlowInstance? flowInstacne;
    SettingController setting = Get.find<SettingController>();
    ResultType<XFlowInstanceArray> result = await KernelApi.getInstance()
        .queryInstance(FlowReq(
            id: id,spaceId: setting.space.id,speciesId: speciesId, page: PageRequest(offset: 0, limit: 9999, filter: '')));

    if (result.success) {
      flowInstacne = result.data!.result!.first;
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
    return flowInstacne;
  }

  static Future<void> approvalTask(
      {required String id, required int status, String? comment}) async {
    ResultType req = await KernelApi.getInstance().approvalTask(
        ApprovalTaskReq(id: id, status: status, comment: comment));

    if (req.success) {
      ToastUtils.showMsg(msg: "成功");
      EventBusHelper.fire(WorkReload());
      Get.back();
    } else {
      ToastUtils.showMsg(msg: req.msg);
    }
  }
}
