


import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ApplicationState extends BaseGetState{
  late TabController tabController;
}

const List<String> tabTitle = [
  "全部",
  "创建的",
  "购买的",
  "共享的",
  "分配的",
];
