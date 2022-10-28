import 'package:flutter/material.dart';
import 'package:orginone/api/workflow_api.dart';
import 'package:orginone/public/http/base_list_controller.dart';
import '../../../api_resp/task_entity.dart';
import 'affairs_type_enum.dart';

/// 办事模块通用的controller
class AffairsListController extends BaseListController<TaskEntity> {
  int limit = 1000;
  int offset = 0;
  AffairsTypeEnum type;

  AffairsListController(this.type){
    debugPrint("--->00 ${type}");
  }

  @override
  void onInit() {
    super.onInit();
    getWaiting();
    debugPrint("--->00 init: ${type}");
    onRefresh();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("--->000 onReady: ${type}");
  }

  @override
  void onRefresh() async {

    debugPrint("--->1 ${type}");
    if(type == AffairsTypeEnum.waiting) {
      var pageResp = await WorkflowApi.task(limit, offset, 'string');
      debugPrint("--->${pageResp.result}");
      addData(true, pageResp);
    }else if(type == AffairsTypeEnum.finish){
      var pageResp = await WorkflowApi.record(limit, offset, 'string');
      addData(true, pageResp);
    }else if(type == AffairsTypeEnum.mine){
      var pageResp = await WorkflowApi.instance(limit, offset, 'string');
      addData(true, pageResp);
    }else if(type == AffairsTypeEnum.copy){

    }
  }

  void onLoadMore() async {}

  Future<void> getWaiting() async {}

  @override
  void dispose() {
    super.dispose();
  }
}
