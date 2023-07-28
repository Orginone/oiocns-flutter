import 'package:get/get.dart';
import 'package:orginone/channel/wallet_channel.dart';
import 'package:orginone/model/wallet_model.dart';
import 'package:orginone/util/hive_utils.dart';

abstract class WalletApi {
  Future<String> loadMnemonicString(int type);

  Future<bool> createWallet(String mnemonics, String account, String passWord);
}

class WalletController extends GetxController implements WalletApi {
  var wallet = <Wallet>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    wallet.value = HiveUtils.getAllWallet();
  }

  @override
  Future<bool> createWallet(
      String mnemonics, String account, String passWord) async {
    var data = await WalletChannel().createWallet(mnemonics, account, passWord);
    if (data != null) {
      wallet.add(data);
    }
    return data != null;
  }

  @override
  Future<String> loadMnemonicString(int type) {
    return WalletChannel().loadMnemonicString(type);
  }

  void clean() {
    wallet.clear();
  }
}

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WalletController(), permanent: true);
  }
}
