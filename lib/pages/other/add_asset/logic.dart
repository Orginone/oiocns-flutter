import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class AddAssetController extends BaseController<AddAssetState> {
  final AddAssetState state = AddAssetState();

  void showFilter() {}

  void selectAll(bool value) {
    state.selectAll.value = value;
    for (var element in state.selectAssetList) {
       if(element.notLockStatus){
         element.isSelected = value;
       }
    }
    state.selectAssetList.refresh();
    state.selectCount.value =  state.selectAssetList.where((p0) => p0.isSelected).length;
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    var list  = AssetManagement().deepCopyAssets();

    List<AssetsInfo> selected = Get.arguments?['selected'] ?? [];
    if(selected.isNotEmpty){
      for (var element in selected) {
        list.where((element1) => element.assetCode == element1.assetCode).first.isSelected = true;
      }
    }
    state.selectAssetList.addAll(list);
    state.selectCount.value = state.selectAssetList.length;
  }

  void openItem(AssetsInfo item) {
    int index = state.selectAssetList.indexOf(item);
    state.selectAssetList[index].isOpen = !state.selectAssetList[index].isOpen;
    state.selectAssetList.refresh();
  }

  void selectItem(AssetsInfo item) {
    int index = state.selectAssetList.indexOf(item);
    if(!state.selectAssetList[index].notLockStatus){
      ToastUtils.showMsg(msg: "该资产已锁定");
      return;
    }
    state.selectAssetList[index].isSelected = !state.selectAssetList[index].isSelected;
    state.selectAssetList.refresh();
    if (state.selectAssetList.where((p0) => p0.isSelected).length ==
        state.selectAssetList.length) {
      if (!state.selectAll.value) {
        state.selectAll.value = true;
      }
    } else {
      if (!(!state.selectAll.value)) {
        state.selectAll.value = false;
      }
    }
    state.selectCount.value =
        state.selectAssetList.where((p0) => p0.isSelected).length;
  }

  void submit() {
    var selected = state.selectAssetList.where((p0) => p0.isSelected);

    Get.back(result: selected.toList());
  }

  void search(String str) {
     if(str.isEmpty){
       state.searchList.clear();
     }else{
       var flitter = state.selectAssetList.where((p0) => p0.assetName?.contains(str)??false);
       if(flitter.isNotEmpty){
         state.searchList.value = flitter.toList();
       }
     }
  }
}