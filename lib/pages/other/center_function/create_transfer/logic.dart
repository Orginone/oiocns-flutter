import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import '../../../../util/production_order_utils.dart';
import 'network.dart';
import 'state.dart';

class CreateTransferController extends BaseController<CreateTransferState> {
  final CreateTransferState state = CreateTransferState();

  bool addedDraft = false;

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (!state.isEdit) {
      state.orderNum.value =
          await ProductionOrderUtils.productionSingleOrder("ZCYJ");
    }
  }

  void choicePeople() {
    Get.toNamed(Routers.choicePeople)?.then((value) {
      if(value!=null){
        state.selectedUser.value = value['user'];
        state.selectedDepartment.value = value['department'];
      }
    });
  }

  void choiceDepartment() {
    Get.toNamed(Routers.choiceDepartment)?.then((value) {
      if(value!=state.selectedDepartment.value){
        state.selectedUser.value = null;
      }
      state.selectedDepartment.value = value;
    });
  }

  void jumpAddAsset() {
    Get.toNamed(Routers.addAsset,arguments: {"selected": state.selectAssetList})?.then((value) {
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
            arguments: {"list": state.selectAssetList.value, "info": "移交明细"})
        ?.then((value) {
      if (value != null) {
        for (var element in value) {
          state.selectAssetList.removeWhere((p0) => p0.assetCode == element);
        }
        state.selectAssetList.refresh();
      }
    });
  }

  void draft() async {
    create(isDraft: true);
  }

  Future submit() async {
    create();
  }

  void create({bool isDraft = false}) async{
    if (state.selectAssetList.isEmpty) {
      return ToastUtils.showMsg(msg: "请至少选择一项资产");
    }
    addedDraft = isDraft;
    await TransferNetWork.createTransfer(
        billCode: state.orderNum.value,
        keeper: state.selectedUser.value,
        keepOrg: state.selectedDepartment.value,
        remark: state.reasonController.text, assets: state.selectAssetList,isDraft: isDraft,isEdit: state.isEdit);
  }

  Future<bool> back() async {
    if (!addedDraft) {
      if ((state.reasonController.text.isNotEmpty ||
              state.selectAssetList.isNotEmpty) &&
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
    if(state.isEdit){
      return true;
    }
    return true;
  }
}
