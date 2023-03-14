import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';


class ProcessApprovalPage extends BaseGetPageView<ProcessApprovalController,ProcessApprovalState>{
  final String str;
  ProcessApprovalPage(this.str);

  @override
  Widget buildView() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(str,style: TextStyle(fontSize: 21.sp,color: Colors.black),),
          Item(),
        ],
      ),
    );
  }

  @override
  ProcessApprovalController getController() {
     return ProcessApprovalController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "${this.toString()}$str";
  }
}