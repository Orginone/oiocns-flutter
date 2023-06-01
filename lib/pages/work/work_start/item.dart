import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
import 'package:orginone/pages/work/work_start/logic.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/target_text.dart';

class Item extends StatelessWidget {
  final IWorkDefine define;

  const Item({Key? key, required this.define}) : super(key: key);


  WorkStartController get work => Get.find<WorkStartController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        WorkNodeModel? node = await define.loadWorkNode();
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
              define.metadata.name ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Text(
                  define.metadata.code??"",
                  style: TextStyle(color: Colors.black38, fontSize: 16.sp),
                ),
                  SizedBox(width: 20.w,),
                  TargetText(
                  userId: define.metadata.belongId??"",
                  style: TextStyle(color: Colors.black38, fontSize: 16.sp),
                ),
                Expanded(
                  child: Text(
                    DateTime.tryParse(define.metadata.createTime ?? "")
                            ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                        "",
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
