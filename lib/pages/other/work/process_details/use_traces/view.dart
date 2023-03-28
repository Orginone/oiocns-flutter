import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../dart/core/getx/base_get_page_view.dart';
import 'logic.dart';
import 'state.dart';

class UseTracesPage extends BaseGetPageView<UseTracesController,UseTracesState>{
  @override
  Widget buildView() {
    return _timeLine();
  }


  Widget _timeLine() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Obx(() {

        int length = state.flowInstance?.flowTaskHistory?.length ?? 0;

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView.builder(
              itemCount: length,
              itemBuilder: (context, index) {
                return Container(
                  child: _buildTimelineTile(
                      index,
                      state.flowInstance!.flowTaskHistory![index]),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTimelineTile(int index, XFlowTask? task) {
    XTarget? user =
    DepartmentManagement().findXTargetByIdOrName(id: task?.createUser ?? "");
    bool isLast = index == state.flowInstance!.flowTaskHistory!.length - 1
        ? true
        : false;
    Widget status = Container();
    if(task?.status == 100){
      status =  Container(
        width: 25.w,
        height: 25.w,
        decoration: const BoxDecoration(
            color: Colors.green, shape: BoxShape.circle),
        child: Icon(
          Icons.done,
          size: 20.w,
          color: Colors.white,
        ),
      );
    }else if(task?.status == 200){
      status =  Container(
        width: 25.w,
        height: 25.w,
        decoration: const BoxDecoration(
            color: Colors.red, shape: BoxShape.circle),
        child: Icon(
          Icons.close,
          size: 20.w,
          color: Colors.white,
        ),
      );
    }

    return TimelineTile(
        isFirst: index == 0 ? true : false,
        isLast: isLast,
        indicatorStyle: IndicatorStyle(
          width: 20.w,
          height: 20.w,
          color: XColors.themeColor,
          indicatorXY: 0,
        ),
        afterLineStyle:
        const LineStyle(thickness: 1, color: XColors.themeColor),
        beforeLineStyle:
        const LineStyle(thickness: 1, color: XColors.themeColor),
        endChild: Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "${task?.flowNode?.name} ",
                      style: TextStyle(color: Colors.black, fontSize: 20.sp),
                    ),
                    TextSpan(
                      text: user?.team?.name ?? "",
                      style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                    )
                  ])),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "流程: ",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                      TextSpan(
                        text: task?.flowNode?.nodeType ?? "",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      )
                    ]),
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "意见: ",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                      TextSpan(
                        text: task?.flowRecords?.last.comment ?? "",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      )
                    ]),
                  ),
                  Text(
                    DateTime.tryParse(task?.createTime ?? "")?.format(
                        format: "yyyy-MM-dd HH:mm:ss") ?? "",
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  )
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.team?.name ?? "",
                          style:
                          TextStyle(color: Colors.black, fontSize: 18.sp)),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "流程节点: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          TextSpan(
                            text: task?.flowNode?.nodeType ?? "",
                            style:
                            TextStyle(color: Colors.grey, fontSize: 16.sp),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              status,
            ],
          ),
        ));
  }


  @override
  UseTracesController getController() {
    return UseTracesController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "UseTraces";
  }
}