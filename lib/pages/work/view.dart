import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/main.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class WorkPage extends BaseFrequentlyUsedListPage<WorkController, WorkState> {
  @override
  Widget buildView() {
    return Container(
      color: GYColors.backgroundColor,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Obx(() {
          return ListView.builder(
            itemBuilder: (context, index) {
              return WorkItem(
                todo: state.dataList[index],
              );
            },
            itemCount: state.dataList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        }),
      ),
    );
  }


  @override
  WorkController getController() {
    return WorkController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "work";
  }
}
