import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/list_adapter.dart';

class BaseFrequentlyUsedListState<T extends FrequentlyUsed, S> extends BaseGetListState<S> {
  var mostUsedList = <T>[].obs;


  ScrollController scrollController= ScrollController();

  var scrollX = (-1.0).obs;

  var adapter = <ListAdapter>[].obs;

  var mode = ListMode.list.obs;
}

enum ListMode{
  list,
  grid;
}

class FrequentlyUsed{
  String? id;
  String? name;
  dynamic avatar;

  FrequentlyUsed({this.id, this.name, this.avatar});
}