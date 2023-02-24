import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/other/assets_config.dart';

import 'state.dart';

class BatchOperationAssetController
    extends BaseController<BatchOperationAssetState> {
  final BatchOperationAssetState state = BatchOperationAssetState();

  void selectAll(bool value) {
    state.selectAll.value = value;
    for (var element in state.selectAssetList) {
      element.isSelected = value;
    }
    state.selectAssetList.refresh();
    state.selectCount.value =
        state.selectAssetList.where((p0) => p0.isSelected).length;
  }

  void openItem(int index) {
    state.selectAssetList[index].isOpen = !state.selectAssetList[index].isOpen;
    state.selectAssetList.refresh();
  }

  void selectItem(int index, bool select) {
    state.selectAssetList[index].isSelected = select;
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

  Future jump(AssetsType type) async {
    if (state.selectAssetList.isEmpty) {
      return Fluttertoast.showToast(msg: "至少选中一项资产");
    }
    var selected = state.selectAssetList.where((p0) => p0.isSelected);
    Get.back();
    Get.toNamed(type.createRoute,
        arguments: {"selected": selected.toList()});
  }
}
