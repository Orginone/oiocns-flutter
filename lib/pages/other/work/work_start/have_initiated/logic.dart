import 'package:get/get.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/pages/other/work/network.dart';
import 'package:orginone/pages/other/work/work_start/network.dart';

import '../../../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';



class HaveInitiatedController extends BaseListController<HaveInitiatedState> {
 final HaveInitiatedState state = HaveInitiatedState();

  HaveInitiatedController();



  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }


  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async{
     state.dataList.value = await WorkStartNetWork.getFlowInstance();
     loadSuccess();
  }

}
