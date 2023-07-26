

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class WalletDetailsState extends BaseGetState{
  late TabController tabController;
}

List<String> tabs = [
  "全部",
  "收款",
  "转账",
];