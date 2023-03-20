import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/images.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'logic.dart';
import 'state.dart';

class ProcessDetailsPage
    extends BaseGetView<ProcessDetailsController, ProcessDetailsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "待办详情",
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(),
                    Obx(() {
                      return Column(
                          children: state.xAttribute.keys.map((title) {
                        return _info(title, state.xAttribute[title]!);
                      }).toList());
                    }),
                    _timeLine(),
                    _annex(),
                    _opinion(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 75.h,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button(
                    text: '终止流程', textColor: Colors.white, color: Colors.red),
                _button(
                    text: '不同意',
                    textColor: XColors.themeColor,
                    border: Border.all(width: 0.5, color: XColors.themeColor)),
                _button(
                    text: '同意',
                    textColor: Colors.white,
                    color: XColors.themeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                Images.defaultAvatar,
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(
                width: 15.w,
              ),
              Text(
                state.task.flowInstance?.title ?? "",
                style: TextStyle(fontSize: 18.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                "资产管理应用",
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "单据编号：ZCCZ20210316001128",
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            "发起时间: ${DateTime.tryParse(state.task.flowInstance?.createTime ?? "")?.format(format: "yyyy-MM-dd HH:mm:ss") ?? ""}",
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _info(String title, Map<XAttribute, dynamic> info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            )),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Column(
                children: info.keys.map((e) {
              String content = "${info[e]}";
              if (e.valueType == "选择型") {
                content = e.dict!.dictItems!
                    .firstWhere((element) => element.value == info[e])
                    .name;
              }
              return _text(title: e.name ?? "", content: content);
            }).toList())),
      ],
    );
  }


  Widget _timeLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              "审批流程",
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Obx(() {
            Widget hide = Container();

            if (state.hideProcess.value) {
              hide = Container(
                width: double.infinity,
                height: 40.h,
                color: Colors.white.withOpacity(0.8),
                alignment: Alignment.center,
                child: GestureDetector(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.w),
                        border: Border.all(color: XColors.themeColor)),
                    child: Text(
                      "查看全部流程(${state.flowInstacne?.flowTaskHistory?.length??0})>",
                      style:
                          TextStyle(color: XColors.themeColor, fontSize: 20.sp),
                    ),
                  ),
                  onTap: () {
                    controller.showAllProcess();
                  },
                ),
              );
            }

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView.builder(
                  itemCount: state.flowInstacne?.flowTaskHistory?.length??0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      child: _buildTimelineTile(index,state.flowInstacne!.flowTaskHistory![index].flowNode!),
                    );
                  },
                ),
                hide,
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _annex() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              "附件",
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            )),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Container()),
      ],
    );
  }

  Widget _opinion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Text(
            "审批意见",
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "意见",
                style: TextStyle(color: Colors.black, fontSize: 20.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16.w)),
                child: TextField(
                  maxLines: 4,
                  maxLength: 140,
                  decoration: InputDecoration(
                      hintText: "请输入您的意见",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade200, fontSize: 24.sp),
                      border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTile(int index,XFlowNode node) {
    XTarget? user = DepartmentManagement().findXTargetByIdOrName(id: node.createUser??"");
    bool isLast = index == state.flowInstacne!.flowTaskHistory!.length - 1 ? true : false;
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
                      text: "${node.name} ",
                      style: TextStyle(color: Colors.black, fontSize: 20.sp),
                    ),
                    TextSpan(
                      text: user?.team?.name??"",
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
                        text: node.nodeType??"",
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
                        text: node.remark??"",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      )
                    ]),
                  ),
                  Text(
                    DateTime.tryParse(node.createTime??"")?.format(format: "yyyy-MM-dd HH:mm:ss")??"",
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
                      Text(user?.team?.name??"",
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
                            text: node.nodeType??"",
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
              !isLast?Container(
                width: 25.w,
                height: 25.w,
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
                child: Icon(
                  Icons.done,
                  size: 20.w,
                  color: Colors.white,
                ),
              ):SizedBox( width: 25.w,
                height: 25.w,),
            ],
          ),
        ));
  }

  Widget _text({required String title, String? content}) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          Text(
            content ?? "",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget _remake({String? title, String? content}) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
              width: double.infinity,
              padding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16.w)),
              child: Text(content ?? "")),
        ],
      ),
    );
  }

  Widget _button(
      {VoidCallback? onTap,
      required String text,
      Color? textColor,
      Color? color,
      BoxBorder? border}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45.h,
        width: 140.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.w),
          border: border,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 20.sp),
        ),
      ),
    );
  }
}
