import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:orginone/model/wallet_model.dart';
import 'package:orginone/util/hive_utils.dart';

class WalletChannel {
  static const channelName = 'WALLET';

  static final WalletChannel _instance = WalletChannel._();

  factory WalletChannel() => _instance;

  late MethodChannel _methodChannel;

  WalletChannel._();

  void init() {
    _methodChannel = const MethodChannel(channelName);
  }

  Future<String> loadMnemonicString(int type) async {
    String mnemonicString =
    await _methodChannel.invokeMethod("loadMnemonicString", {"type": type});
    return mnemonicString;
  }

  Future<Wallet?> createWallet(String mnemonics, String account,
      String passWord) async {
    Wallet? wallet;
    dynamic json = await _methodChannel.invokeMethod("createWallet",
        {"mnemonics": mnemonics, "account": account, "passWord": passWord});
    if (json.isNotEmpty) {
      wallet = Wallet.fromJson(jsonDecode(json));
      HiveUtils.putWallet(wallet);
    }
    return wallet;
  }
}
