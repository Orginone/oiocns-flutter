import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/work_start/logic.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/target_text.dart';

class Item extends StatelessWidget {
  final IWorkDefine define;

  final VoidCallback? onTap;

  final PopupMenuItemSelected? onSelected;

  const Item({Key? key, required this.define, this.onTap, this.onSelected})
      : super(key: key);

  WorkStartController get work => Get.find<WorkStartController>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10.w, left: 10.w, top: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    define.metadata.name ?? "",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    define.metadata.name ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        define.metadata.code ?? "",
                        style:
                            TextStyle(color: Colors.black38, fontSize: 18.sp),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      TargetText(
                        userId: define.metadata.belongId ?? "",
                        style:
                            TextStyle(color: Colors.black38, fontSize: 16.sp),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Obx(() {
              PopupMenuItem popupMenuItem;
              if (settingCtrl.work.isMostUsed(define)) {
                popupMenuItem = const PopupMenuItem(
                  value: "remove",
                  child: Text("移除常用"),
                );
              } else {
                popupMenuItem = const PopupMenuItem(
                  value: "set",
                  child: Text("设为常用"),
                );
              }
              return CommonWidget.commonPopupMenuButton(items: [
                popupMenuItem,
              ], onSelected: onSelected);
            }),
          ],
        ),
      ),
    );
  }
}
