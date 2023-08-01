import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/wallet_model.dart';

import 'state.dart';

class SearchCoinController extends BaseController<SearchCoinState> {
 final SearchCoinState state = SearchCoinState();

  void addCoin(Map<String, String> item) {
   state.wallet.value.coins ??= [];
   state.wallet.value.coins!.add(Coin.fromJson(item));
   state.wallet.refresh();
   walletCtrl.updateWallet(state.wallet.value);
  }

  void removeCoin(Map<String, String> item) {
   state.wallet.value.coins!.removeWhere((element) => element.type == item['type']);
   state.wallet.refresh();
   walletCtrl.updateWallet(state.wallet.value);
  }
}
