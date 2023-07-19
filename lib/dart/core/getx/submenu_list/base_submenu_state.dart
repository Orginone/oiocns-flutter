import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/subgroup.dart';

import 'list_adapter.dart';

class BaseSubmenuState<T extends FrequentlyUsed> extends BaseGetState {

  late Rx<SubGroup> subGroup;

  var adapter = <ListAdapter>[].obs;

  var submenuIndex = 0.obs;

  PageController pageController = PageController();

  String tag = '';
}

class FrequentlyUsed{
  String? id;
  String? name;
  dynamic avatar;

  FrequentlyUsed({this.id, this.name, this.avatar});
}