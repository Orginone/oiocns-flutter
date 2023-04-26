import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/work/work_list/state.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import '../item.dart';
import 'logic.dart';

class WorkListPage extends BaseGetListView<WorkListController,WorkListState>{
  @override
  Widget buildView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      itemBuilder: (context, index) {
        return Item(
          todo: state.dataList[index],
        );
      },
      itemCount: state.dataList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  @override
  // TODO: implement title
  String get title => state.work.name;

  @override
  List<Widget>? actions() {
    return [
      IconButton(onPressed: (){
        controller.createWork();
      }, icon: Icon(Icons.add,color: Colors.black,)),
    ];
  }
}