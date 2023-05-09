import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'logic.dart';
import 'state.dart';
import 'item.dart';

class WorkPage extends BaseGetListPageView<WorkController, WorkState> {
  @override
  Widget buildView() {
    return Container(
      color: GYColors.backgroundColor,
      child: SingleChildScrollView(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 10.h),
          itemBuilder: (context, index) {
            return Item(
               todo: state.dataList[index],
            );
          },
          itemCount: state.dataList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
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
