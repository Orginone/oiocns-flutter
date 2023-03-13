import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';

class Item extends StatelessWidget {
  const Item({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "资产转移单",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24.sp,
                color: Colors.black),
          ),
          SizedBox(height: 4.h,),
          Text(
            "单据编号:xxxxxxxxx",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Colors.black),
          ),
          SizedBox(height: 4.h,),
          Text(
            "提交人:xxxxxx",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Colors.black),
          ),
          SizedBox(height: 4.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "提交日期:2023-09-01 12:23:21",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: Colors.black),
              ),
              // Text("不同意",style: TextStyle(fontSize: 16.sp,color: Colors.red),),
              GestureDetector(
                onTap: () {
                  int index = Random().nextInt(5);
                  Get.toNamed(Routers.approveDocuments,
                      arguments: {"type": DocumentsType.values[index]});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: const Text("去审批"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
