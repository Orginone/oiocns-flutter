import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class ProcessInfoPage extends BaseGetPageView<ProcessInfoController,ProcessInfoState>{
  @override
  Widget buildView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Column(
                      children: state.useForm.map((form) {
                        return _info(form);
                      }).toList());
                }),
                _opinion(),
              ],
            ),
          ),
        ),
        _approval(),
      ],
    );
  }


  Widget _approval() {
    if (state.task.status != 1) {
      return Container();
    }
    return Container(
      width: double.infinity,
      height: 120.h,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _button(
              text: '退回',
              textColor: Colors.white,
              color: Colors.red,
              onTap: () {
                controller.approval(200);
              }),
          _button(
              text: '通过',
              textColor: Colors.white,
              color: XColors.themeColor, onTap: () {
            controller.approval(100);
          }),
        ],
      ),
    );
  }

  Widget _info(XForm form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidget.commonHeadInfoWidget(form.name??""),
        CommonWidget.commonFormWidget(
            formItem: form.attributes?.map((e) {
              String content = "${e.remark}";
              return CommonWidget.commonFormItem(
                  title: e.name ?? "", content: content);
            }).toList()??[]),
      ],
    );
  }

  Widget _opinion() {
    if (state.task.status != 1) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget("审批意见"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            margin: EdgeInsets.symmetric(horizontal: 15.w),
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
                    controller: state.comment,
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
      ),
    );
  }


  Widget _button({VoidCallback? onTap,
    required String text,
    Color? textColor,
    Color? color,
    BoxBorder? border}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45.h,
        width: 200.w,
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
  @override
  ProcessInfoController getController() {
    return ProcessInfoController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "ProcessInfo";
  }
}