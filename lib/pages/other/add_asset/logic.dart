import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'mock.dart';
import 'state.dart';

class AddAssetController extends BaseController<AddAssetState> {
  final AddAssetState state = AddAssetState();

  void showFilter() {}

  void selectAll(bool value) {
    state.selectAll.value = value;
    for (var element in state.selectAssetList) {
      element.isSelected = value;
    }
    state.selectAssetList.refresh();
    state.selectCount.value =  state.selectAssetList.where((p0) => p0.isSelected).length;
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    var mockList = await Executor().execute(
        arg1: AddAssetMock['data']['list'] as List<Map<String, dynamic>>,
        fun1: getMockListModel);
    state.selectAssetList.addAll(mockList);
  }

  void openItem(int index) {
    state.selectAssetList[index].isOpen = !state.selectAssetList[index].isOpen;
    state.selectAssetList.refresh();
  }

  void selectItem(int index) {
    if(!state.selectAssetList[index].notLockStatus){
      Fluttertoast.showToast(msg: "该资产已锁定");
      return;
    }
    state.selectAssetList[index].isSelected = !state.selectAssetList[index].isSelected;
    state.selectAssetList.refresh();
    if (state.selectAssetList.where((p0) => p0.isSelected).length ==
        state.selectAssetList.length) {
      if (!state.selectAll.value) {
        state.selectAll.value = true;
      }
    } else {
      if (!(!state.selectAll.value)) {
        state.selectAll.value = false;
      }
    }
    state.selectCount.value =
        state.selectAssetList.where((p0) => p0.isSelected).length;
  }

  void submit() {
    var selected = state.selectAssetList.where((p0) => p0.isSelected);

    Get.back(result: selected.toList());
  }
}

Future<List<SelectAssetList>> getMockListModel(
    List<Map<String, dynamic>> json, TypeSendPort sendPort) async {
  List<SelectAssetList> list = [];

  if (json.isNotEmpty) {
    for (var value in json) {
      list.add(SelectAssetList.fromJson(value));
    }
  }

  return list;
}
