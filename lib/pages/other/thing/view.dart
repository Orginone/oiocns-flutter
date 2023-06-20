import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ThingPage extends BaseGetListView<ThingController, ThingState> {
  @override
  Widget buildView() {
    return ListView.builder(itemBuilder: (context, index) {
        return Item(
          item: state.dataList[index],
          onSelected: (key) {
            controller.operation(key,state.dataList[index]);
          },
        );
      }, itemCount: state.dataList.length,);
  }

  @override
  // TODO: implement title
  String get title => state.form.metadata.name!;
}