import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/production_order_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'network.dart';
import 'state.dart';

class CreateDisposeController extends BaseController<CreateDisposeState> {
  final CreateDisposeState state = CreateDisposeState();

  bool addedDraft = false;

  Future<bool> back() async {
    if (!addedDraft) {
      if ((state.disposeType.isNotEmpty ||
              state.reasonController.text.isNotEmpty ||
              state.selectAssetList.isNotEmpty ||
              state.assessment.value.isNotEmpty ||
              state.phoneNumberController.text.isNotEmpty ||
              state.unitController.text.isNotEmpty||state.unitType.value.isNotEmpty || state.assessment.value.isNotEmpty) &&
          !state.isEdit) {
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
    if (state.isEdit) {
      return true;
    }
    return true;
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (!state.isEdit) {
      state.orderNum =
          await ProductionOrderUtils.productionSingleOrder("ZCCZ");
    }
  }

  void showProcessingMethod() {
    PickerUtils.showListStringPicker(context, titles: DisposeTyep,
        callback: (str) {
      state.disposeType.value = str;
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
  }

  void submit() async {
    if (state.disposeType.value.isEmpty) {
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
    create();

  }

  void showUnit() {
    PickerUtils.showListStringPicker(context, titles: AssetAcceptanceUnitType,
        callback: (str) {
      state.unitType.value = str;
    });
  }

  void showAssessment() {
    PickerUtils.showListStringPicker(context, titles: Whether, callback: (str) {
      state.assessment.value = str;
    });
  }

  void create({bool isDraft = false}) async{
    int keepOrgType = 0;
    int evaluated = 0;
    if(state.unitType.value.isNotEmpty){
      keepOrgType = AssetAcceptanceUnitType.indexOf(state.unitType.value);
    }
    if(state.assessment.value.isNotEmpty){
      evaluated = Whether.indexOf(state.assessment.value);
    }
    int phoneNum = 0;
    if(state.phoneNumberController.text.isNotEmpty){
      if(state.phoneNumberController.text.length!=11){
        Fluttertoast.showToast(msg: "请输入正确的手机号");
      }else{
        phoneNum = int.parse(state.phoneNumberController.text);
      }
    }

    await DisposeNetwork.createDispose(
        way: DisposeTyep.indexOf(state.disposeType.value),
        keepOrgType: keepOrgType,
        keepOrgName: state.unitController.text,
        evaluated: evaluated,
        phoneNumber: phoneNum,
        billCode: state.orderNum,
        assets: state.selectAssetList,
        remark: state.reasonController.text,isDraft: isDraft);
  }
}
