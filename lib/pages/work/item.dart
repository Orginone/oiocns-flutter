import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/images.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/target_text.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';
import 'state.dart';

class WorkItem extends StatelessWidget {
  final IWorkTask todo;

  const WorkItem({Key? key, required this.todo}) : super(key: key);

  WorkController get controller => Get.find<WorkController>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await todo.loadInstance();
        Get.toNamed(Routers.processDetails, arguments: {"todo": todo});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 0.4))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.h),
                child: ImageWidget(
                  todo.metadata.avatarThumbnail() ?? Images.iconWorkitem,
                  size: 70.w,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            todo.metadata.taskType ?? "",
                            style: TextStyle(fontSize: 19.sp),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            height: 20.h,
                            width: 0.5,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: Text(
                              todo.metadata.title ?? "",
                              style: TextStyle(fontSize: 19.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: statusMap[todo.metadata.status]!
                                  .color
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.w),
                              border: Border.all(
                                  color: statusMap[todo.metadata.status]!.color,
                                  width: 0.5),
                            ),
                            child: Text(
                              statusMap[todo.metadata.status]!.text,
                              style: TextStyle(
                                  color: statusMap[todo.metadata.status]!.color,
                                  fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      role(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(child: comment()),
                          Text(
                              '创建时间: ${DateTime.tryParse(todo.metadata.createTime ?? "")?.format(format: "yyyy-MM-dd HH:mm:ss") ?? ""}',
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey)),
                        ],
                      ),
                      // button(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    if (todo.metadata.status != 1 || todo.metadata.approveType != "审批") {
      return Container();
    }

    Widget button = Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              controller.approval(todo, 200);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 60.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  // color: Colors.red,
                  border: Border.all(color: Colors.red,width: 0.5)
              ),
              child: Text(
                "拒绝",
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(width: 15.w,),
          GestureDetector(
            onTap: () {
              controller.approval(todo, 100);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 60.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                color: XColors.themeColor,
              ),
              child: Text(
                "同意",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
    return button;
  }

  Widget comment() {
    String content = todo.metadata.content ?? "";
    if (content.isEmpty) {
      return const SizedBox();
    }

    if (todo.targets.length == 2) {
      content =
          "${todo.targets[0].name}[${todo.targets[0].typeName}]申请加入${todo.targets[1].name}[${todo.targets[1].typeName}]";
    }
    return Text(
      "内容:$content",
      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
    );
  }

  Widget role() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: XColors.tinyBlue),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: TargetText(
              userId: todo.metadata.createUser ?? "",
              style: TextStyle(fontSize: 12.sp, color: XColors.designBlue)),
        ),
        SizedBox(
          width: 10.w,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: XColors.tinyBlue),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: TargetText(
              userId: todo.metadata.shareId ?? "",
              style: TextStyle(fontSize: 12.sp, color: XColors.designBlue)),
        ),
      ],
    );
  }
}
