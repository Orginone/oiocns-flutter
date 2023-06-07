import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/target_text.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';
import 'state.dart';

class WorkItem extends StatelessWidget {
  final XWorkTask todo;

  const WorkItem({Key? key, required this.todo}) : super(key: key);

  WorkController get controller => Get.find<WorkController>(tag: 'work');

  SettingController get setting => Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(todo.taskType == "事项"){
          Get.toNamed(Routers.processDetails,arguments: {"todo":todo});
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h,right: 14.w,left: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  todo.taskType,
                  style: TextStyle(fontSize: 22.sp),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 20.h,
                  width: 0.5,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: statusMap[todo.status]!.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(
                        color: statusMap[todo.status]!.color, width: 0.5),
                  ),
                  child: Text(
                    statusMap[todo.status]!.text,
                    style: TextStyle(
                        color: statusMap[todo.status]!.color,
                        fontSize: 18.sp),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            comment(),
            role(),
            SizedBox(
              height: 10.h,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '创建时间: ',
                      style:
                          TextStyle(fontSize: 18.sp, color: Colors.grey)),
                  TextSpan(
                    text: DateTime.tryParse(todo.createTime)
                            ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                        "",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button(){
    if(todo.status !=1){
      return Container();
    }

    Widget button = Column(
      children: [
        GestureDetector(
          onTap: (){
            controller.approval(todo, 100);
          },
          child: Container(
            padding:
            EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              color: XColors.themeColor,
            ),
            child: Text(
              "通过",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ),
        SizedBox(height: 10.h,),
        GestureDetector(
          onTap: (){
            controller.approval(todo, 200);
          },
          child: Container(
            padding:
            EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              color: Colors.red,
            ),
            child: Text(
              "退回",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        )
      ],
    );
    return button;
  }

  Widget comment() {
    String content = todo.content;
    if (content.isEmpty) {
      return SizedBox();
    }

    if (todo.taskType == '加用户' && todo.content.isNotEmpty) {
      List<dynamic> json = jsonDecode(todo.content);
      List<XTarget> targets = json.map((e) => XTarget.fromJson(e)).toList();
      if (targets.length == 2) {
        content =
            "${targets[0].name}[${targets[0].typeName}]申请加入${targets[1].name}[${targets[1].typeName}]";
      }
    }
    return Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Text(
          "内容:$content",
          style: TextStyle(fontSize: 16.sp),
        ));
  }

  Widget role() {
    return Row(
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(
              text: '创建人: ',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey)),
          WidgetSpan(
            child: TargetText(
                userId: todo.createUser ?? "",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
          ),
        ])),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          height: 20.h,
          width: 0.5,
          color: Colors.grey,
        ),
        TargetText(
          style: TextStyle(fontSize: 18.sp),
          userId: todo.shareId ?? "",
        ),
      ],
    );
  }
}

