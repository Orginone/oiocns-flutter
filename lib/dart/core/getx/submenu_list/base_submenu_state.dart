import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/util/page_view_scroll_utils.dart';

import 'list_adapter.dart';

class BaseSubmenuState<T extends FrequentlyUsed> extends BaseGetState {

  late Rx<SubGroup> subGroup;

  var submenuIndex = 0.obs;

  late TabController tabController;

  String tag = '';

  late PageViewScrollUtils pageViewScrollUtils;
}

class FrequentlyUsed{
  String? id;
  String? name;
  dynamic avatar;

  FrequentlyUsed({this.id, this.name, this.avatar});
}