import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/subgroup.dart';

class BaseSubmenuState<T extends FrequentlyUsed> extends BaseGetState {

  late Rx<SubGroup> subGroup;

  var submenuIndex = 0.obs;

  late TabController tabController;

  String tag = '';
}

class FrequentlyUsed{
  String? id;
  String? name;
  dynamic avatar;

  FrequentlyUsed({this.id, this.name, this.avatar});
}