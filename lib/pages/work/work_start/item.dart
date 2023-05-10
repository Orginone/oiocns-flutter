import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/pages/work/work_start/logic.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class Item extends StatelessWidget {
  final XWorkDefine define;

  const Item({Key? key, required this.define}) : super(key: key);


  WorkStartController get work => Get.find<WorkStartController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        WorkNodeModel? node = await (work.state.work.space! as IWork).loadWorkNode(define.id!);
        if (node != null &&
            node.forms != null &&
            node.forms!.isNotEmpty) {
          Get.toNamed(Routers.createWork,arguments: {"define":define,"node":node});
        } else {
          return ToastUtils.showMsg(msg: "流程未绑定表单");
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.w, left: 10.w, top: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              define.name ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "需求主体:${work.state.work.space?.metadata.name ?? ""}",
                  style: TextStyle(color: Colors.black38, fontSize: 16.sp),
                ),
                Text(
                  DateTime.tryParse(define.createTime ?? "")
                          ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                      "",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
