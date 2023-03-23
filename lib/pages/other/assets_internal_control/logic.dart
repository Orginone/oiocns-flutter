import 'package:get/get.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/asset_management.dart';

import '../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';

class AssetsInternalControlController extends BaseListController<AssetsInternalControlState> {
 final AssetsInternalControlState state = AssetsInternalControlState();



 @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async{
    await AssetManagement().initAssets();
    state.dataList.value = AssetManagement().assets;
    loadSuccess();
  }

  void jumpBatchAssets() {
    var list = state.dataList.where((p0) => p0.notLockStatus).toList();
    Get.toNamed(
      Routers.batchOperationAsset,
      arguments: {
        "list": list,
      },
    );
  }
}
