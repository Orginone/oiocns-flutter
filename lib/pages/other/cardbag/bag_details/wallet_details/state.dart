

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/wallet_model.dart';

class WalletDetailsState extends BaseGetState{
  late TabController tabController;

  late Coin coin;

  WalletDetailsState(){
    coin = Get.arguments['coin'];
  }
}

List<String> tabs = [
  "全部",
  "收款",
  "转账",
];