import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/utils/hive_utils.dart';

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

  Future<Wallet?> createWallet(
      String mnemonics, String account, String passWord) async {
    Wallet? wallet;
    dynamic json = await _methodChannel.invokeMethod("createWallet",
        {"mnemonics": mnemonics, "account": account, "passWord": passWord});
    if (json != null && json.isNotEmpty) {
      wallet = Wallet.fromJson(jsonDecode(json));
      HiveUtils.putWallet(wallet);
    }
    return wallet;
  }

  Future<Map<String, dynamic>?> getBalance(Map<String, dynamic> params) async {
    dynamic data = await _methodChannel.invokeMethod("getBalance", params);
    if (data != null && data.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(data);
      return json;
    }
    return null;
  }

  Future<List<TransactionRecord>> transactionsByaddress(
      Map<String, dynamic> params) async {
    List<TransactionRecord> records = [];
    dynamic data =
        await _methodChannel.invokeMethod("transactionsByaddress", params);
    if (data != null && data.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(data);
      if (json['result'] != null) {
        json['result'].forEach((json) {
          records.add(TransactionRecord.fromJson(json));
        });
      }
      return records;
    } else {
      Map<String, dynamic> json = transactions;
      if (json['result'] != null) {
        json['result'].forEach((json) {
          records.add(TransactionRecord.fromJson(json));
        });
      }
      return records;
    }
  }

  Future<bool> createTransaction(Map<String, dynamic> params) async {
    dynamic data =
        await _methodChannel.invokeMethod("createTransaction", params);
    return data != null;
  }
}

const transactions = {
  "id": 1,
  "result": [
    {
      "blocktime": 1605774673,
      "fee": "0.007",
      "from": "1P7P4v3kL39zugQgDDLRqxdddddddfKs",
      "height": 11097152,
      "note": "",
      "status": "1",
      "to": "1KgE3vayiqZKhfhMftN7vtddddMk941",
      "txid": "0x3b4f885b01370509be01e258f2ddddd7fc01f65d578d9156a6887f3667c8d",
      "type": "receive",
      "value": "3"
    },
    {
      "blocktime": 1602750506,
      "fee": "0.007",
      "from": "1KgE3vayiqZKhfhMftddddHoMk941",
      "height": 10499717,
      "note": "",
      "status": "1",
      "to": "1NkcL7c2LLESnZQgi2dddddKByemsPa5",
      "txid": "0x4fc738785a0e792660858f65d5a9dddddccbc37b1229bd4c5d32fed1c7",
      "type": "send",
      "value": "0.1"
    }
  ],
  "error": null
};
