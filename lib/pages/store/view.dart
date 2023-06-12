import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/widget/unified.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class StorePage extends BaseFrequentlyUsedListPage<StoreController, StoreState> {
  @override
  Widget buildView() {
    return Container(
      color: XColors.bgColor,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return StoreItem();
        },
        itemCount: state.dataList.length,
      ),
    );
  }


  @override
  StoreController getController() {
    return StoreController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "WareHouse";
  }
}
