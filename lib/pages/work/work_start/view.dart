import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';


class WorkStartPage extends BaseGetView<WorkStartController, WorkStartState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "事项",
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Item(
                  define: state.defines[index],
                );
              },
              itemCount: state.defines.length,
            );
          }),
        ),
      ),
    );
  }
}