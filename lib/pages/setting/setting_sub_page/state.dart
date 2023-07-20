


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/setting/home/state.dart';

class SettingSubState extends BaseGetListState{
   Rxn<SettingNavModel> nav = Rxn();

   ScrollController scrollController = ScrollController();
}