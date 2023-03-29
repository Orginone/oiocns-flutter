import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/event_bus_helper.dart';

import '../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';

class AssetsInternalControlController extends BaseListController<AssetsInternalControlState> {
 final AssetsInternalControlState state = AssetsInternalControlState();



   @override
  void onReceivedEvent(event) async{
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is InitHomeData) {
      await loadData();
    }
  }


 @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async{
   try {
     if (KernelApi.getInstance().anystore.isOnline) {
       await AssetManagement().initAssets();
       state.dataList.value = AssetManagement().assets;
       loadSuccess();
     } else {
       await Future.delayed(const Duration(milliseconds: 200), () async {
         loadFailed();
         await loadData();
        });
     }
   } catch (e) {

   }

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
