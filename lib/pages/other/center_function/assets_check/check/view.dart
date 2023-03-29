import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class CheckPage extends BaseGetListPageView<CheckController, CheckState> {
  final CheckType checkType;

  CheckPage(this.checkType);

  @override
  Widget buildView() {
    return SingleChildScrollView(
      child: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Item(
              checkType: checkType,
              onInventory: (type) {
                controller.inventory(type,index);
              },
              onRecheck: () {
                controller.recheck(index);
              }, assets: state.dataList[index],
            );
          },
          itemCount: state.dataList.length,
        );
      }),
    );
  }

  @override
  Widget headWidget() {
    // TODO: implement headWidget
    return super.headWidget();
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
