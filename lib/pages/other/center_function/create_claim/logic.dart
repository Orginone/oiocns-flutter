import 'package:get/get.dart';
import 'package:orginone/event/choice_assets.dart';
import 'package:orginone/pages/other/storage_location/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CreateClaimController extends BaseController<CreateClaimState> {
  final CreateClaimState state = CreateClaimState();


  //明细下标用于数据填充
  int index = 0;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.detailedData.add(DetailedData());
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
        state.detailedData[index].assetClassification =
            event.selectedAsset!.categoryName!;
        state.detailedData.refresh();
      }
    }
  }

  void choicePlace(int index) {
    this.index = index;
    Get.toNamed(Routers.storageLocation)?.then((value){
      if(value!=null && value is StorageLocation){
        state.detailedData[index].place = value.placeName??"";
        state.detailedData.refresh();
      }
    });
  }

  void newCreate(int index) {
    List<String> title = ["是", "否"];
    PickerUtils.showListStringPicker(context, titles: title, callback: (str) {
      state.detailedData[index].newCreate = title.indexOf(str) == 0;
      state.detailedData.refresh();
    });
  }

  void addDetailed() {
    state.detailedData.add(DetailedData());
  }

  void deleteDetailed(int index) {
    state.detailedData.removeAt(index);
  }
}
