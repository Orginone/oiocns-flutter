

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';

class Item extends StatelessWidget {
  final XFlowInstance item;
  const Item({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor;
    String status;
    if(item.status == 100){
      textColor = Colors.green;
      status = "已同意";
    }else if(item.status == 1){
      textColor = Colors.blue.shade500;
      status = "待处理";
    }else{
      textColor = Colors.red;
      status = "已拒绝";
    }

    Widget tips = Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: textColor,width: 0.5),
      ),
      child: Text(status,style: TextStyle(color: textColor,fontSize: 14.sp),),
    );
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routers.processDetails,arguments: {"task":item.flowTaskHistory?.last});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateTime.tryParse(item.createTime ?? "")
                      ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                      "",
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 16.sp),
                ),
                tips,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
