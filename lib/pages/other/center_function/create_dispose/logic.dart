import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CreateDisposeController extends BaseController<CreateDisposeState> {
  final CreateDisposeState state = CreateDisposeState();

  bool addedDraft = false;

  Future<bool> back() async {
    if (!addedDraft) {
      if ((state.disposeTyep.isNotEmpty ||
          state.reasonController.text.isNotEmpty ||
          state.selectAssetList.isNotEmpty) && !state.isEdit) {
        YYBottomSheetDialog(context, DraftTips, callback: (i, str) {
          if (i == 0) {
            draft();
            Get.back();
          } else if (i == 1) {
            Get.back();
          }
        });
      }
    }
    return false;
  }

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
    Get.toNamed(Routers.addAsset,
        arguments: {"selected": state.selectAssetList})?.then((value) {
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

  void draft() {
    addedDraft = true;
    KernelApi.getInstance().anystore.insert(
        "create_dispose_draft",
        {
          "DISPOSE_CODE": DisposeTyep.indexOf(state.disposeTyep.value),
          "REASON": state.reasonController.text,
          "ASSET":
              state.selectAssetList.map((element) => element.toJson()).toList()
        },
        "user");
  }

  void submit() {
    if (state.disposeTyep.value.isEmpty) {
      Fluttertoast.showToast(msg: "请选择处置方式");
      return;
    }
    if (state.reasonController.text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入申请原因");
      return;
    }
    if (state.selectAssetList.isEmpty) {
      Fluttertoast.showToast(msg: "请至少选择一项资产");
      return;
    }
    KernelApi.getInstance().anystore.update("asset_disposal", {

    }, "company");
    Get.back();
  }
}
