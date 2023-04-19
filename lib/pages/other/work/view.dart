import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';import 'package:orginone/components/unified.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Item(
            task: state.type!=WorkEnum.done && state.type!=WorkEnum.completed?state.dataList[index]:null,
            type: state.type,
            history:state.type==WorkEnum.done||state.type==WorkEnum.completed?state.dataList[index]:null,
          );
        },
        itemCount: state.dataList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
