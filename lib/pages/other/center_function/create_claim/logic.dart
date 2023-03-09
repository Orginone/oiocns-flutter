import 'package:get/get.dart';
import 'package:orginone/event/choice_assets.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/create_claim/netwrok.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/production_order_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CreateClaimController extends BaseController<CreateClaimState> {
  final CreateClaimState state = CreateClaimState();

  //明细下标用于数据填充
  int index = 0;

  bool addedDraft = false;

  Fields? fields;

  // Future<bool> back() async {
  //   if (!addedDraft) {
  //     if (((state.detailedData.where((p0) => p0.hasFilled()).isNotEmpty) || !state.config.config![0].hasFilled()) &&
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


  void choiceAssetClassification(int index) {
    this.index = index;
    Get.toNamed(Routers.choiceAssets);
  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is ChoiceAssets) {
      if (event.selectedAsset != null) {
        fields!.defaultData.value = event.selectedAsset!;
        state.detailedData.refresh();
      }
    }
  }

  void choicePlace(int index) {
    this.index = index;
    // Get.toNamed(Routers.storageLocation)?.then((value){
    //   if(value!=null && value is StorageLocation){
    //     state.detailedData[index].location = value.placeName??"";
    //     state.detailedData.refresh();
    //   }
    // });
  }

  void addDetailed() {
    state.detailedData.add(state.config.config![1].toNewConfig());
  }

  void deleteDetailed(int index) {
    state.detailedData.removeAt(index);
  }

  Future draft() async{
    create(isDraft: true);
  }

  Future submit() async{
    create();
  }

  Future create({bool isDraft = false}) async {

    for (var element in state.config.config![0].fields!) {
      if(element.required??false){
        if(element.defaultData.value == null){
          return ToastUtils.showMsg(msg: element.hint??"");
        }
      }
    }
    for (var element in state.detailedData) {
      for (var element1 in element.fields!) {
        if(element1.required??false){
          if(element1.defaultData.value == null){
            return ToastUtils.showMsg(msg: element1.hint??"");
          }
        }
      }
    }
    addedDraft = true;
    ClaimNetWork.creteClaim(basic: state.config.config?[0].fields??[], detail: state.detailedData,isDraft: isDraft,isEdit: state.isEdit);
  }

  void functionAlloc(Fields e) {
    fields = e;
    if (e.type == "router") {
      Get.toNamed(e.router!);
    }
    if (e.type == "select") {
      PickerUtils.showListStringPicker(context, titles: e.select!.keys.toList(),
          callback: (str) {
        e.defaultData.value = {str: e.select![str]};
      });
    }
  }
}
