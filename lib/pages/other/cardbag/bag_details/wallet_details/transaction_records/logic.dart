import 'package:get/get.dart';
import 'package:orginone/channel/wallet_channel.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/pages/other/cardbag/bag_details/wallet_details/logic.dart';

import 'state.dart';

class TransactionRecordsController
    extends BaseListController<TransactionRecordsState> {
  final TransactionRecordsState state = TransactionRecordsState();

  final int type;

  TransactionRecordsController(this.type);

  WalletDetailsController get details => Get.find();

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    Map<String, dynamic> params = details.state.coin.toJson();
    params['count'] = 20;
    params['index'] = state.page;
    params['type'] = type;
    var data = await WalletChannel().transactionsByaddress(params);
    loadSuccess();
    if (state.page == 0) {
      state.dataList.clear();
    }
    state.dataList.addAll(data);
    state.dataList.refresh();
  }
}
