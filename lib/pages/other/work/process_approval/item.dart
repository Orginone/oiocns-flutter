import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/images.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';

class Item extends StatelessWidget {

  final XFlowTask task;

  const Item({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Get.toNamed(Routers.processDetails,arguments: {"task":task});
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
                  Image.asset(Images.defaultAvatar),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    task.flowInstance?.title??"",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.w),
                          border: Border.all(color: Colors.grey, width: 0.5),
                        ),
                        child: Text(
                          "资产管理应用",
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              Text("紧急程度:中",style: TextStyle(color: Colors.black87, fontSize: 16.sp),),
              SizedBox(height: 20.h,),
              Text("单据编号:NKZCBX20220707000086",style: TextStyle(color: Colors.black87, fontSize: 16.sp),),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Text.rich(TextSpan(
                    children: [
                      TextSpan(text: DepartmentManagement().findXTargetByIdOrName(id: task.createUser??"")?.team?.name??"",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500)),
                      TextSpan(text: "发起",style: TextStyle(fontSize: 16.sp,color: Colors.grey)),
                    ]
                  )),
                  SizedBox(
                    width: 20.w,
                  ),
                 Container(
                   height: 20.h,
                   width: 0.5,
                   color: Colors.grey,
                 ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    DateTime.tryParse(task.flowInstance?.createTime??"")?.format(format: "yyyy-MM-dd HH:mm:ss")??"",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.w),
                          color: XColors.themeColor,
                          border: Border.all(color: Colors.grey, width: 0.5),
                        ),
                        child: Text(
                          "去审批",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
