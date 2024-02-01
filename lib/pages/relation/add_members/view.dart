import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class AddMembersPage
    extends BaseGetView<AddMembersController, AddMembersState> {
  const AddMembersPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.title,
      body: Column(
        children: [
          CommonWidget.commonSearchBarWidget(
              controller: state.searchController,
              onChanged: (str) {
                controller.search(str);
              },
              hint: "搜索账号",
              showLine: true),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Obx(() {
                          return CommonWidget.commonMultipleChoiceButtonWidget(
                              isSelected: state.selectAll.value,
                              changed: (value) {
                                controller.selectAll();
                              });
                        }),
                        SizedBox(
                          width: 10.w,
                        ),
                        Obx(() {
                          String text = "全选";
                          if (state.selectedMember.isNotEmpty) {
                            text = "已选中${state.selectedMember.length}项";
                          }
                          return Text(text);
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(() {
                    if (state.showSearch.value) {
                      return Column(
                        children: state.searchMember
                            .map((element) => item(element))
                            .toList(),
                      );
                    }
                    return Column(
                      children: state.unitMember
                          .map((element) => item(element))
                          .toList(),
                    );
                  })
                ],
              ),
            ),
          ),
          CommonWidget.commonSubmitWidget(submit: () {
            controller.back();
          }),
        ],
      ),
    );
  }

  Widget item(XTarget item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Obx(() {
            return CommonWidget.commonMultipleChoiceButtonWidget(
                isSelected: state.selectedMember.contains(item),
                changed: (value) {
                  controller.addItem(item);
                });
          }),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.w),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "账号:${item.code}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: Text(
                          "昵称:${item.name}",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16.sp),
                        ),
                      ),
                      Text(
                        "姓名:${item.name}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "手机号:${item.code}",
                    style: TextStyle(color: Colors.black54, fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
