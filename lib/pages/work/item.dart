import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/todo/todo.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';
import 'state.dart';

class Item extends StatelessWidget {
  final ITodo todo;

  const Item({Key? key, required this.todo}) : super(key: key);

  WorkController get controller => Get.find<WorkController>(tag: 'work');

  SettingController get setting => Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    String title = '';

    return Slidable(
      key: const ValueKey("assets"),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: "标记已读",
            onPressed: (BuildContext context) {

            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: "删除",
            onPressed: (BuildContext context) {

            },
          ),
        ],
      ),
      child: GestureDetector(
        onTap: (){
          Get.toNamed(Routers.processDetails,arguments: {"todo":todo});
        },
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    todo.type,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    height: 20.h,
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  Text(
                    todo.name,
                    style: TextStyle(fontSize: 18.sp),
                  ),

                  SizedBox(width: 10.w,),
                  Text(
                    DateTime.tryParse(todo.createTime)?.format(format: "yyyy-MM-dd HH:mm:ss")??"",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(width: 10.w,),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color:
                      statusMap[todo.status]!.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(
                          color: statusMap[todo.status]!.color,
                          width: 0.5),
                    ),
                    child: Text(
                      statusMap[todo.status]!.text,
                      style: TextStyle(
                          color: statusMap[todo.status]!.color,
                          fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        comment(),
                        SizedBox(
                          height: 20.h,
                        ),
                        role(),
                      ],
                    ),
                  ),
                  button(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button(){
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

  Widget comment(){
    return Container(
        margin: EdgeInsets.only(top: 20.h), child: Text("备注:${todo.remark}",style: TextStyle(fontSize: 16.sp),));
  }

  Widget role() {

    return Row(
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(
              text: '创建人:', style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
          TextSpan(
              text: setting.provider.findNameById(todo.createUser),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
        ])),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          height: 20.h,
          width: 0.5,
          color: Colors.grey,
        ),
        Text(
          setting.provider.findNameById(todo.shareId),
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    );
  }
}

