import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/custom_paint.dart';

import 'logic.dart';
import 'state.dart';



class ApprovalProcessPage extends BaseGetPageView<ApprovalProcessController,ApprovalProcessState>{
  @override
  Widget buildView() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Material(
            shape: CustomTopNotchShape(),
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "审批流程",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Stepper(
                    physics: const NeverScrollableScrollPhysics(),
                    elevation: 0,
                    currentStep: 1,
                    margin: EdgeInsets.zero,
                    steps: [
                      Step(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '提交审批',
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              Text(
                                '芳',
                                style: TextStyle(fontSize: 20.sp,color: Colors.black),
                              ),
                            ],
                          ),
                          subtitle: Text(
                          '2021-10-12 12:21:11',
                          style: TextStyle(fontSize: 16.sp),
    ),
                          state: StepState.complete,
                          content: Container(),
                          isActive: true),
                      Step(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '退回',
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            Text(
                              '2人或签',
                              style: TextStyle(fontSize: 20.sp,color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: (){
                                controller.showDetails();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade200)
                                ),
                                height: 40.w,
                                width: 40.w,
                                alignment: Alignment.center,
                                child: const Icon(Icons.chevron_right),
                              ),
                            )
                          ],
                        ),
                        subtitle: Text(
                          '2021-10-12 12:21:11',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        state: StepState.complete,
                        content: Container(),
                        isActive: true,
                      ),
                      Step(
                        title: Text(
                          '重新提交',
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        state: StepState.indexed,
                        content: Container(),
                      ),
                    ],
                    controlsBuilder: (context, details) {
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }



  @override
  ApprovalProcessController getController() {
    return ApprovalProcessController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}