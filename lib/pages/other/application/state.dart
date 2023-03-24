


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/market/index.dart';

class ApplicationState extends BaseGetState{
  late TabController tabController;

  var products = <IProduct>[].obs;
}

const List<String> tabTitle = [
  "全部",
  "共享的",
  "可用的",
  "创建的",
  "购买的",
];
