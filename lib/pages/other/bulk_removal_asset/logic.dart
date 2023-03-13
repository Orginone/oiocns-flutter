import 'package:get/get.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class BulkRemovalAssetController extends BaseController<BulkRemovalAssetState> {
  final BulkRemovalAssetState state = BulkRemovalAssetState();

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

  void delete() {
    var selected = state.selectAssetList.where((p0) => p0.isSelected);
    Get.back(result: selected.map((e) => e.assetCode).toList());
  }
}
