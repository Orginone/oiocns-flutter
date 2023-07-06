import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/widget/unified.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class StorePage
    extends BaseFrequentlyUsedListPage<StoreController, StoreState> {
  @override
  Widget buildView() {
    return Container(
      color: XColors.bgColor,
      child: Obx(() {
        return ListView.builder(
          itemBuilder: (context, index) {
            var item = state.dataList[index];
            return StoreItem(item: item,);
          },
          itemCount: state.dataList.length,
        );
      }),
    );
  }
}
