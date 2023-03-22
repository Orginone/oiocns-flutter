import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/choice_thing/state.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';

class ChoiceThingPage
    extends BaseGetView<ChoiceThingController, ChoiceThingState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "实体",
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemBuilder: (context, index) {
                  var item = state.things[index];
                  return Item(item: item,changed: (value){
                    controller.changeSelected(index,value);
                  },);
                },
                itemCount: state.things.length,
              );
            }),
          ),
          CommonWidget.commonSubmitWidget(submit: () {
            controller.submit();
          })
        ],
      ),
    );
  }
}