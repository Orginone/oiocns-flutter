import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CreateDisposeController extends BaseController<CreateDisposeState> {
  final CreateDisposeState state = CreateDisposeState();

  void showProcessingMethod() {
   PickerUtils.showListStringPicker(context, titles: DisposeTyep,
       callback: (str) {
        state.disposeTyep.value = str;
       });
  }

  void jumpBulkRemovalAsset() {
    Get.toNamed(Routers.bulkRemovalAsset,
        arguments: {"list": state.selectAssetList.value,"info":"处置明细"})?.then((value) {
      if (value != null) {
        for (var element in value) {
          state.selectAssetList.removeWhere((p0) => p0.id == element);
        }
        state.selectAssetList.refresh();
      }
    });
  }

  void jumpAddAsset() {
   Get.toNamed(Routers.addAsset)?.then((value) {
    if (value != null) {
     state.selectAssetList.clear();
     state.selectAssetList.addAll(value);
     state.selectAssetList.refresh();
    }
   });
  }

  void openInfo(int index) {
    state.selectAssetList[index].isOpen = !state.selectAssetList[index].isOpen;
    state.selectAssetList.refresh();
  }

  void removeItem(int index) {
    state.selectAssetList.removeAt(index);
  }
}
