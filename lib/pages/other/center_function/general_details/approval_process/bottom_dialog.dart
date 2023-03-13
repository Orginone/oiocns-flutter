import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApprovalBottomDialog {
  static Future<void> showDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 400.h,
          width: double.infinity,
          child: Column(
            children: [
              _head(context),
              _item(),
            ],
          ),
        );
      },
    );
  }

  static Widget _head(context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
          )),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: Text(
              "拒绝",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            "2人或签-详细",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  size: 32.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _item() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric( horizontal: 15.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.w,top: 10.h),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                  width: 12.w,
                  height: 12.w,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "拒绝",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.red),
                      ),
                      SizedBox(height: 10.h,),
                      Text("01/13 22:22:22",style: TextStyle(color: Colors.grey,fontSize: 16.sp),),
                    ],
                  )
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "芳",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
