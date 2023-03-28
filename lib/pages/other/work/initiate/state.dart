

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class InitiateState extends BaseGetState{
  late TabController tabController;
}


const List<String> tabTitle = [
  '发起',
  '草稿',
  '已发起',
  '已完结'
];