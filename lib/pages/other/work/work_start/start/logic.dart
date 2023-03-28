import 'package:get/get.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/pages/other/work/work_start/network.dart';

import '../../../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';




class StartController extends BaseListController<StartState> {
 final StartState state = StartState();

 final ISpeciesItem species;

  StartController(this.species);

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async{
   state.dataList.value = await WorkStartNetWork.getFlowDefine(species.id);
   loadSuccess();
  }
}
