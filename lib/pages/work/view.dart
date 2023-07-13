import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/list_adapter.dart';
import 'package:orginone/main.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class WorkPage extends BaseFrequentlyUsedListPage<WorkController, WorkState> {
  @override
  Widget buildView() {
    return Obx((){
      state.adapter.value = state.dataList.map((element) => ListAdapter.work(element)).toList();
      return super.buildView();
    });
  }
}
