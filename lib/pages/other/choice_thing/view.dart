import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/choice_thing/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';

class ChoiceThingPage
    extends BaseGetListView<ChoiceThingController, ChoiceThingState> {
  @override
  Widget buildView() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = state.dataList[index];
                return Item(item: item,changed: (value){
                  controller.changeSelected(index,value);
                },);
              },
              itemCount: state.dataList.length,
            );
          }),
        ),
        CommonWidget.commonSubmitWidget(submit: () {
          controller.submit();
        })
      ],
    );
  }

  @override
  // TODO: implement title
  String get title => "实体";
}