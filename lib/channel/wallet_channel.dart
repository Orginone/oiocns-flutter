import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:orginone/model/transaction_record_model.dart';
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

  Future<Wallet?> createWallet(String mnemonics, String account, String passWord) async {
    Wallet? wallet;
    dynamic json = await _methodChannel.invokeMethod("createWallet",
        {"mnemonics": mnemonics, "account": account, "passWord": passWord});
    if (json!=null && json.isNotEmpty) {
      wallet = Wallet.fromJson(jsonDecode(json));
      HiveUtils.putWallet(wallet);
    }
    return wallet;
  }

  Future<Map<String, dynamic>?> getBalance(Map<String, dynamic> params) async {
    dynamic data = await _methodChannel.invokeMethod("getBalance",params);
    if (data!=null && data.isNotEmpty) {
      Map<String,dynamic> json = jsonDecode(data);
      return json;
    }
    return null;
  }

  Future<List<TransactionRecord>> transactionsByaddress(Map<String, dynamic> params) async {
    List<TransactionRecord> records = [];
    dynamic data = await _methodChannel.invokeMethod("transactionsByaddress",params);
    if (data!=null && data.isNotEmpty) {
      Map<String,dynamic> json = jsonDecode(data);
      if(json['result']!=null){
        json['result'].forEach((json){
          records.add(TransactionRecord.fromJson(json));
        });
      }
      return records;
    }
    return records;
  }
}

