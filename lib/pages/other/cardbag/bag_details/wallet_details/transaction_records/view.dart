import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class TransactionRecordsPage extends BaseGetListPageView<TransactionRecordsController,TransactionRecordsState>{

  final int type;

  TransactionRecordsPage(this.type);
  @override
  Widget buildView() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var item = state.dataList[index];
        return RecordItem(record: item,);
      },
      itemCount: state.dataList.length,
    );
  }

  @override
  TransactionRecordsController getController() {
    return TransactionRecordsController(type);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "TransactionRecords_$type";
  }
}
