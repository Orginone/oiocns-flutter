import 'package:get/get.dart';
import 'package:orginone/event/choice.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/event_bus_helper.dart';

import '../../../../dart/core/getx/base_controller.dart';
import '../logic.dart';
import 'state.dart';

class ChoiceSpecificAssetsController
    extends BaseController<ChoiceSpecificAssetsState> {


  final ChoiceSpecificAssetsState state = ChoiceSpecificAssetsState();


  ChoiceAssetsController get choiceAssetController => Get.find<ChoiceAssetsController>();

  void search(String str) {}

  void previousStep() {
    if (state.selectedSecondLevelAsset.value != null) {
     state.selectedSecondLevelAsset.value = null;
    }
  }

  void selectLevelItem(AssetsCategoryGroup item,int index) {
    state.selectedSecondLevelAsset.value = item;
    changeSecondLevelChildIndex(index);
  }

  void selectItem(AssetsCategoryGroup item) {
   choiceAssetController.selectItem(item);
  }

  void back() {
    EventBusHelper.fire(ChoiceAssets(choiceAssetController.state.selectedAsset.value));

    Get.until((route) {
      return (route as GetPageRoute).settings.name == Routers.createClaim;
    });
  }

  void changeChildIndex(int index) {
    if(state.selectedChildIndex.value == index){
      return;
    }
    state.selectedChildIndex.value = index;
  }

  void changeSecondLevelChildIndex(int index) {
    if(state.selectedSecondLevelChildIndex.value == index){
      return;
    }
    state.selectedSecondLevelChildIndex.value = index;
  }
}
