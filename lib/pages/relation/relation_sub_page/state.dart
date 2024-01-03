import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/pages/relation/index.dart';

class RelationSubState extends BaseGetListState {
  Rxn<RelationNavModel> nav = Rxn();

  ScrollController scrollController = ScrollController();

  late List<ShortcutData> shortcutDatas;
}
