import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class AddMembersPage
    extends BaseGetView<AddMembersController, AddMembersState> {
  @override
  Widget buildView() {
    return GyScaffold(
        titleName: state.title,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
              child: Row(
                children: [
                  Obx(() {
                    return CommonWidget.commonMultipleChoiceButtonWidget(
                        isSelected: state.selectAll.value, changed: (value) {
                      controller.selectAll();
                    });
                  }),
                  SizedBox(width: 10.w,),
                  const Text("全选"),
                ],
              ),
            ),
          ],
        )
    );
  }
}