


import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/util/page_view_scroll_utils.dart';

class IndexState extends BaseGetState{

  late TabController tabController;

  late PageViewScrollUtils pageViewScrollUtils;

}

const List<String> tabTitle = [
  "动态",
  "共享软件",
  "公物仓",
  "公益仓",
  "数据资产",
];
