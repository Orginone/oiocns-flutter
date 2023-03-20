


import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/util/toast_utils.dart';

class WorkNetWork{

  static Future<List<XFlowTask>> getApproveTask({required String type})async {
    List<XFlowTask>  tasks= [];

    SettingController setting = Get.find<SettingController>();

    ResultType<XFlowTaskArray> result = await KernelApi.getInstance().queryApproveTask(IdReq(id: setting.space.id));
    
    if(result.success){
      tasks = result.data?.result??[];
      tasks.removeWhere((element) => element.flowNode?.nodeType != type);
    }else{
      ToastUtils.showMsg(msg: result.msg);
    }
    
    return tasks;
  }

  static Future<XFlowInstance?> getFlowInstance({required String id})async {
    XFlowInstance? flowInstacne;
    ResultType<XFlowInstanceArray> result = await KernelApi.getInstance().queryInstance(FlowReq(id: id,page: PageRequest(offset: 0, limit: 9999, filter: '')));

    if(result.success){
      flowInstacne = result.data!.result!.first;
    }else{
      ToastUtils.showMsg(msg: result.msg);
    }
    return flowInstacne;
  }

}
