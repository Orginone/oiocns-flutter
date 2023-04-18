import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';

import 'network.dart';
import 'state.dart';

class WorkController extends BaseListController<WorkState> with GetTickerProviderStateMixin{
 final WorkState state = WorkState();





 @override
 Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
   if(state.type == WorkEnum.done || state.type == WorkEnum.completed){
     state.dataList.value = await WorkNetWork.getRecord(state.type == WorkEnum.done?[1]:[100,200]);
   }else{
     state.dataList.value = await WorkNetWork.getApproveTask(type: state.type.label);
   }
   loadSuccess();
 }

 void approval(String id,int status) async{
   await WorkNetWork.approvalTask(id: id??"", status: status,comment: '');
 }

}
