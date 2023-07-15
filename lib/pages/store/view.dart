import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/list_adapter.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/unified.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class StorePage
    extends BaseFrequentlyUsedListPage<StoreController, StoreState> {
  @override
  Widget buildView() {
    return Obx((){
      state.adapter.value = state.dataList.map((element) => ListAdapter.store(element)).toList();
      return super.buildView();
    });
  }
}
