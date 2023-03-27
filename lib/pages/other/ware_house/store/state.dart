

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class StoreState extends BaseGetState{
  late TabController tabController;
}

const List<String> tabTitle = [
  '全部',
  '开放市场',
  '自建商店',
  '加入商店',
];