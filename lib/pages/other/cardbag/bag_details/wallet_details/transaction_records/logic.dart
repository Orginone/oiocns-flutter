import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/other/cardbag/bag_details/wallet_details/logic.dart';

import 'state.dart';

class TransactionRecordsController
    extends BaseListController<TransactionRecordsState> {
  @override
  final TransactionRecordsState state = TransactionRecordsState();

  final int type;

  TransactionRecordsController(this.type);

  WalletDetailsController get details => Get.find();

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    var data = await walletCtrl.transactionsByaddress(
        details.state.coin, state.page, type);
    loadSuccess();
    if (state.page == 0) {
      state.dataList.clear();
    }
    state.dataList.addAll(data);
    state.dataList.refresh();
  }
}
