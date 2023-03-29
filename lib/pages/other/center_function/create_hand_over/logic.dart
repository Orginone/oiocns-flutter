import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/event/choice.dart';
import 'package:orginone/model/asset_creation_config.dart';
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
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is ChoicePeople) {
      for (var element in state.config.config!) {
        for (var element in element.fields!) {
          if (element.code == "USER_NAME") {
            element.defaultData.value = event.user;
          }
        }
      }
    }
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
    create();
  }

  void draft() async {
    create(isDraft: true);
  }

  // Future<bool> back() async {
  //   if (!addedDraft) {
  //     if ((state.reasonController.text.isNotEmpty ||
  //             state.selectAssetList.isNotEmpty || state.selectedUser.value!=null) &&
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

  void create({bool  isDraft = false}) async{
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
    await HandOverNetWork.createHandOver(
        assets: state.selectAssetList, isDraft: isDraft,isEdit: state.isEdit, basic: state.config.config?[0].fields??[]);

  }

}
