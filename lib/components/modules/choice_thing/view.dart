import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/modules/choice_thing/index.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';
import 'item.dart';

class ChoiceThingPage
    extends BaseGetListView<ChoiceThingController, ChoiceThingState> {
  ChoiceThingPage({super.key});

  @override
  Widget buildView() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = state.dataList[index];
                return Item(
                  item: item,
                  changed: (value) {
                    controller.changeSelected(index, value);
                  },
                );
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
