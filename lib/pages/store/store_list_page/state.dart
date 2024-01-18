import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/pages/store/models/index.dart';

class StoreListState extends BaseGetListState {
  StoreTreeNavModel? nav;

  ScrollController scrollController = ScrollController();
}
