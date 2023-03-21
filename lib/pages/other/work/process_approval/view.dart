import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/pages/other/work/state.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';


class ProcessApprovalPage extends BaseGetListPageView<ProcessApprovalController,ProcessApprovalState>{
  final WorkEnum type;
  ProcessApprovalPage(this.type);

  @override
  Widget buildView() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type.label,style: TextStyle(fontSize: 21.sp,color: Colors.black),),
          Expanded(
            child: ListView.builder(itemBuilder: (context,index){
              return Item(task: state.dataList[index],type: type,);
            },itemCount: state.dataList.length,),
          )
        ],
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