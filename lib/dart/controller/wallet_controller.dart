import 'package:get/get.dart';
import 'package:orginone/channel/wallet_channel.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/utils/hive_utils.dart';

abstract class WalletApi {
  Future<String> loadMnemonicString(int type);

  Future<bool> createWallet(String mnemonics, String account, String passWord);

  Future<void> queryWalletBalance(Wallet wallet);

  Future<List<TransactionRecord>> transactionsByaddress(
      Coin coin, int page, int type);

  Future<bool> createTransaction(
      Coin coin, String amount, String to, String note);

  void updateWallet(Wallet wallet);
}

class WalletController extends GetxController implements WalletApi {
  var wallet = <Wallet>[].obs;

  @override
  void onReady() {
    super.onReady();
    wallet.value = HiveUtils.getAllWallet();
  }

  @override
  Future<bool> createWallet(
      String mnemonics, String account, String passWord) async {
    var data = await WalletChannel().createWallet(mnemonics, account, passWord);
    if (data != null) {
      data.coins ??= [];
      data.coins!.add(Coin.fromJson(DEFAULT_COINS[0]));
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

  @override
  void updateWallet(Wallet wallet) {
    HiveUtils.putWallet(wallet);
    this.wallet.refresh();
  }

  @override
  Future<void> queryWalletBalance(Wallet wallet) async {
    if (wallet.coins != null) {
      Future.wait(wallet.coins!
              .map((e) => WalletChannel().getBalance(e.toJson()))
              .toList())
          .then((data) {
        if (data.isNotEmpty) {
          for (var element in data) {
            if (element != null) {
              String address = element['result']['address'];
              String balance = element['result']['balance'];
              var coin = wallet.coins!
                  .firstWhereOrNull((element) => element.address == address);
              if (coin != null) {
                coin.balance = balance;
              }
            }
          }
          updateWallet(wallet);
        }
      });
    }
  }

  @override
  Future<List<TransactionRecord>> transactionsByaddress(
      Coin coin, int page, int type) async {
    Map<String, dynamic> params = coin.toJson();
    params['count'] = 20;
    params['index'] = page;
    params['type'] = type;
    var data = await WalletChannel().transactionsByaddress(params);
    return data;
  }

  @override
  Future<bool> createTransaction(
      Coin coin, String amount, String to, String note) async {
    Map<String, dynamic> json = coin.toJson();
    json['amount'] = amount;
    json['fee'] = '0';
    json['from'] = coin.address;
    json['to'] = to;
    json['note'] = note;
    bool success = await WalletChannel().createTransaction(json);
    return success;
  }
}

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WalletController(), permanent: true);
  }
}
