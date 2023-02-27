import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/event/choice_assets.dart';
import 'package:orginone/pages/other/storage_location/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/production_order_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import '../../assets_config.dart';
import 'netwrok.dart';
import 'state.dart';

class CreateClaimController extends BaseController<CreateClaimState> {
  final CreateClaimState state = CreateClaimState();


  //明细下标用于数据填充
  int index = 0;

  bool addedDraft = false;

  Future<bool> back() async {
    if (!addedDraft) {
      if ((state.detailedData.isNotEmpty ||
          state.reasonController.text.isNotEmpty ||
          state.orderNum.isEmpty) &&
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

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    if (!state.isEdit) {
      state.orderNum.value =
          await ProductionOrderUtils.productionSingleOrder("ZCSY");
    }
  }

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
        state.detailedData[index].assetType = event.selectedAsset!;
        state.detailedData.refresh();
      }
    }
  }

  void choicePlace(int index) {
    this.index = index;
    Get.toNamed(Routers.storageLocation)?.then((value){
      if(value!=null && value is StorageLocation){
        state.detailedData[index].location = value.placeName??"";
        state.detailedData.refresh();
      }
    });
  }

  void newCreate(int index) {
    List<String> title = ["是", "否"];
    PickerUtils.showListStringPicker(context, titles: title, callback: (str) {
      state.detailedData[index].isDistribution = title.indexOf(str) == 0;
      state.detailedData.refresh();
    });
  }

  void addDetailed() {
    state.detailedData.add(ClaimDetailed());
  }

  void deleteDetailed(int index) {
    state.detailedData.removeAt(index);
  }

  void draft() {
    addedDraft = true;
    create(isDraft: true);
  }

  Future submit() async{
    if(state.reasonController.text.isEmpty){
      return ToastUtils.showMsg(msg: "请输入申领事由");
    }
    if(state.detailedData.where((p0) => p0.assetType == null).isNotEmpty){
      return ToastUtils.showMsg(msg: "请选择资产分类");
    }
    if(state.detailedData.where((p0) => p0.assetNameController.text.isEmpty).isNotEmpty){
      return ToastUtils.showMsg(msg: "请输入资产名称");
    }
    create();
  }

  void create({bool isDraft = false}){
    ClaimNetWork.creteClaim(billCode: state.orderNum.value, remark: state.reasonController.text, detail: state.detailedData,isDraft: isDraft);
  }
}
