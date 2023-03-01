import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/create_hand_over/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/production_order_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CreateHandOverController extends BaseController<CreateHandOverState> {
  final CreateHandOverState state = CreateHandOverState();

  bool addedDraft = false;

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (!state.isEdit) {
      state.orderNum.value =
          await ProductionOrderUtils.productionSingleOrder("ZCJH");
    }
  }

  void choicePeople() {
    Get.toNamed(Routers.choicePeople)?.then((value) {
      state.selectedUser.value = value;
    });
  }

  void choiceDepartment() {
    Get.toNamed(Routers.choiceDepartment)?.then((value) {
      state.selectedDepartment.value = value;
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

  void jumpBulkRemovalAsset() {
    Get.toNamed(Routers.bulkRemovalAsset,
            arguments: {"list": state.selectAssetList.value, "info": "交回明细"})
        ?.then((value) {
      if (value != null) {
        for (var element in value) {
          state.selectAssetList.removeWhere((p0) => p0.assetCode == element);
        }
        state.selectAssetList.refresh();
      }
    });
  }

  Future submit() async {
    if (state.reasonController.text.trim().isEmpty) {
      return ToastUtils.showMsg(msg: "请输入移交原因");
    }
    if (state.selectAssetList.isEmpty) {
      return ToastUtils.showMsg(msg: "请至少选择一项资产");

    }
    LoadingDialog.showLoading(context);


    create();
    LoadingDialog.dismiss(context);
  }

  void draft() async {
    addedDraft = true;
    create(isDraft: true);
  }

  Future<bool> back() async {
    if (!addedDraft) {
      if ((state.reasonController.text.isNotEmpty ||
              state.selectAssetList.isNotEmpty || state.selectedUser.value!=null) &&
          !state.isEdit) {
        YYBottomSheetDialog(context, DraftTips, callback: (i, str) {
          if (i == 0) {
            draft();
          } else if (i == 1) {
            Get.back();
          }
        });
      }
    }
    if (state.isEdit) {
      return true;
    }
    return true;
  }

  void create({bool  isDraft = false}) async{
    await HandOverNetWork.createHandOver(
        billCode: state.orderNum.value,
        remark: state.reasonController.text,
        assets: state.selectAssetList,
        userName: state.selectedUser.value!.name,isDraft: isDraft);
  }
}
