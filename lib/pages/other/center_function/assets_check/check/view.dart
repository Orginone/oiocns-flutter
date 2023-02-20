import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class CheckPage extends BaseGetListPageView<CheckController, CheckState> {
  final CheckType checkType;

  CheckPage(this.checkType);

  @override
  Widget buildView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Item(
          checkType: checkType,
          onInventory: (type) {
            controller.inventory(type);
          },
          onRecheck: () {
            controller.recheck();
          },
        );
      },
      itemCount: state.dataList.length,
    );
    ;
  }

  @override
  CheckController getController() {
    return CheckController(checkType);
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString() + checkType.name;
  }
}
