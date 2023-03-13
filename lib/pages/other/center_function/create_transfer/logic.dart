import 'package:get/get.dart';
import 'package:orginone/event/choice.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'network.dart';
import 'state.dart';

class CreateTransferController extends BaseController<CreateTransferState> {
  final CreateTransferState state = CreateTransferState();

  bool addedDraft = false;

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is ChoicePeople) {
      for (var element in state.config.config!) {
        for (var element in element.fields!) {
          if (element.code == "KEEPER_NAME") {
            element.defaultData.value = event.user;
          }
          if (element.code == "KEEP_ORG_NAME") {
            state.selectedDepartment = event.department;
            element.defaultData.value = event.department;
          }
        }
      }
    }
    if (event is ChoiceDepartment) {
      for (var element in state.config.config!) {
        for (var element in element.fields!) {
          if (element.code == "KEEPER_NAME" &&
              event.department != state.selectedDepartment) {
            element.defaultData.value = null;
          }
          if (element.code == "KEEP_ORG_NAME") {
            element.defaultData.value = event.department;
          }
        }
      }
    }
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
    for (var element in state.config.config![0].fields!) {
      if(element.required??false){
        if(element.defaultData.value == null){
          return ToastUtils.showMsg(msg: element.hint??"");
        }
      }
    }
    if (state.selectAssetList.isEmpty) {
      return ToastUtils.showMsg(msg: "请至少选择一项资产");
    }
    addedDraft = isDraft;
    await TransferNetWork.createTransfer(
        assets: state.selectAssetList,isDraft: isDraft,isEdit: state.isEdit, basic: state.config.config?[0].fields??[],);
  }

  // Future<bool> back() async {
  //   if (!addedDraft) {
  //     if ((state.reasonController.text.isNotEmpty ||
  //             state.selectAssetList.isNotEmpty) &&
  //         !state.isEdit) {
  //       YYBottomSheetDialog(context, DraftTips, callback: (i, str) {
  //         if (i == 0) {
  //           draft();
  //         } else if (i == 1) {
  //           Get.back();
  //         }
  //       });
  //     }
  //   }
  //   if (state.isEdit) {
  //     return true;
  //   }
  //   return true;
  // }

}
