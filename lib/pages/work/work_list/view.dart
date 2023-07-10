import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';
import 'package:orginone/pages/work/work_list/state.dart';
import '../item.dart';
import 'logic.dart';

class WorkListPage extends BaseGetListView<WorkListController,WorkListState>{
  @override
  Widget buildView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.h),
      itemBuilder: (context, index) {
        return WorkItem(
          todo: state.dataList[index],
        );
      },
      itemCount: state.dataList.length,
    );
  }

  @override
  // TODO: implement title
  String get title => state.work.name;
}