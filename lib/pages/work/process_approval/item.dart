import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/work/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';

import 'logic.dart';
import 'view.dart';

class Item extends StatelessWidget {

  final XFlowTask? task;

  final WorkEnum type;

  final XFlowTaskHistory? history;

  const Item({Key? key, this.task, required this.type, this.history}) : super(key: key);


  ProcessApprovalController get controller => Get.find(tag: 'ProcessApproval_${type.label}');


  @override
  Widget build(BuildContext context) {
    String title = '';
    if(type == WorkEnum.done || type == WorkEnum.completed){
      // title = history?.historyTask?.flowInstance?.title??"";
    }else{
      title = task?.flowInstance?.title??"";
    }

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
          var data;
          if(type == WorkEnum.done || type == WorkEnum.completed ){
            // data = history?.historyTask;
          }else{
            data = task;
          }
          Get.toNamed(Routers.processDetails,arguments: {"task":data,"type":type});
        },
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18.sp),
                    ),
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
            controller.approval(task?.id??"", 100);
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
            controller.approval(task?.id??"", 200);
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
    if(type == WorkEnum.done || type == WorkEnum.completed){
      Color textColor = history!.status == 100?Colors.green:Colors.red;

      button = Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(color: textColor,width: 0.5),
        ),
        child: Text(history!.status == 100?"已同意":"已拒绝",style: TextStyle(color: textColor,fontSize: 14.sp),),
      );
    }else if(type == WorkEnum.copy){
      button = Container();
    }
    return button;
  }

  Widget comment(){
    if(type != WorkEnum.done && type != WorkEnum.completed){
      return Container();
    }
    // return Container(margin: EdgeInsets.only(top: 20.h),child: Text("备注:${history?.comment??""}"));
    return Container(margin: EdgeInsets.only(top: 20.h),child: Text("备注:${""}"));
  }

  Widget role() {
    String roleType = type == WorkEnum.done ||type == WorkEnum.completed? "审批" : "发起";
    String dateTime = DateTime.tryParse((type == WorkEnum.done ||type == WorkEnum.completed
                    ? history?.updateTime
                    : task?.flowInstance?.createTime) ??
                "")
            ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
        "";

    String userId = (type == WorkEnum.done||type == WorkEnum.completed?history?.createUser:task?.createUser)??"";
    SettingController setting = Get.find<SettingController>();

    return Row(
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(
              text: setting.provider.findNameById(userId),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          TextSpan(
              text: roleType,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
        ])),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 20.h,
          width: 0.5,
          color: Colors.grey,
        ),
        Text(
          dateTime,
          style: TextStyle(fontSize: 18.sp),
        ),
      ],
    );
  }
}
