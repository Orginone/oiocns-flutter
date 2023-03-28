import 'package:orginone/pages/other/work/work_start/network.dart';
import 'package:orginone/util/common_tree_management.dart';

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
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    var allSpecies = CommonTreeManagement().species?.getAllList();

    if (allSpecies != null) {
      for (var value in allSpecies) {
        var list = await WorkStartNetWork.getFlowInstance(speciesId: value.id);
        state.dataList.value.addAll(list);
      }
    }
    loadSuccess();
  }
}
