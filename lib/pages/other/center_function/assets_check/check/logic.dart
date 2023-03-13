import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/event/check_reload.dart';
import 'package:orginone/pages/other/center_function/assets_check/logic.dart';

import '../dialog.dart';
import 'network.dart';
import 'state.dart';

class CheckController extends BaseListController<CheckState> {
  final CheckState state = CheckState();
  final CheckType checkType;

  AssetsCheckController get assetsCheckController =>
      Get.find<AssetsCheckController>();

  CheckController(this.checkType);

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    state.dataList.value = await CheckNetwork.queryCheckList(
        stockTaskCode: assetsCheckController.state.assetUse.billCode ?? "",
        status: checkType.index);
    state.dataList.refresh();
    loadSuccess();
  }

  void inventory(CheckType type, int index) {
    CheckDialog.showInventoryDialog(
      context,
      title: type.name,
      onSubmit: (str) async {
        CheckNetwork.performInventory(
            status: type == CheckType.saved ? 1 : 2,
            code: state.dataList[index].assetCode ?? "",
            remark: str);
      },
    );
  }

  void recheck(int index) {
    CheckNetwork.performInventory(
        status: 0,
        code: state.dataList[index].assetCode ?? "",
    );
  }

  @override
  void onReceivedEvent(event) async {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is CheckReload) {
      await loadData();
    }
  }

  void allInventory() {
    CheckNetwork.allInventory(assets: state.dataList);
  }
}
