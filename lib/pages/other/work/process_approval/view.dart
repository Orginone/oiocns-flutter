import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/pages/other/work/state.dart';

import '../to_do/state.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';


class ProcessApprovalPage extends BaseGetListPageView<ProcessApprovalController,ProcessApprovalState>{
  final WorkEnum type;
  ProcessApprovalPage(this.type);

  @override
  Widget buildView() {
    return Container(
      color: GYColors.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Item(
            task: type!=WorkEnum.done?state.dataList[index]:null,
            type: type,
            history:type==WorkEnum.done?state.dataList[index]:null,
          );
        },
        itemCount: state.dataList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  @override
  ProcessApprovalController getController() {
     return ProcessApprovalController(type);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "${this.toString()}${type.label}";
  }
}