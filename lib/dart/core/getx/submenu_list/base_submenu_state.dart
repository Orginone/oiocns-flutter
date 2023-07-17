import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';

import 'list_adapter.dart';

class BaseSubmenuState<T extends FrequentlyUsed, S> extends BaseGetListState<S> {

  var submenu = <SubmenuType>[].obs;

  var adapter = <ListAdapter>[].obs;

  var submenuIndex = 0.obs;

  PageController pageController = PageController();
}

class FrequentlyUsed{
  String? id;
  String? name;
  dynamic avatar;

  FrequentlyUsed({this.id, this.name, this.avatar});
}

class SubmenuType{
  final String text;
  final String value;

  SubmenuType({required this.text,required this.value});
}