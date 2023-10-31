import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/pages/work/work_list/state.dart';
import 'logic.dart';

class WorkListPage extends BaseGetListView<WorkListController, WorkListState> {
  WorkListPage({super.key});

  @override
  Widget buildView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.h),
      itemBuilder: (context, index) {
        return ListItem(
          adapter: ListAdapter.work(state.dataList[index]),
        );
      },
      itemCount: state.dataList.length,
    );
  }

  @override
  String get title => state.work.name;
}
