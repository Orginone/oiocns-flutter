import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class BaseSubmenuState<T extends FrequentlyUsed> extends BaseGetState {
  late Rx<SubGroup> subGroup;
  var submenuIndex = 0.obs;

  late TabController tabController;

  String tag = '';

  var tabIndex = 0;
}

class FrequentlyUsed {
  String? id;
  String? name;
  dynamic avatar;

  FrequentlyUsed({this.id, this.name, this.avatar});
}
