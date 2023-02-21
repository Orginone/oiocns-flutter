import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/routers.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import '../../../../util/production_order_utils.dart';
import 'state.dart';

class CreateTransferController extends BaseController<CreateTransferState> {
  final CreateTransferState state = CreateTransferState();


  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    state.orderNum.value = await ProductionOrderUtils.productionSingleOrder("ZCYJ");
  }

  void choicePeople() {
    Get.toNamed(Routers.choicePeople)?.then((value) {
      state.selectedUser.value = value;
    });
  }

  void choiceDepartment() {
    Get.toNamed(Routers.choiceDepartment)?.then((value) {
      state.selectedDepartment.value = value;
    });
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
        arguments: {"list": state.selectAssetList.value,"info":"移交明细"})?.then((value) {
      if (value != null) {
        for(var element in value){
          state.selectAssetList.removeWhere((p0) => p0.id == element);
        }
        state.selectAssetList.refresh();
      }
    });
  }
}
