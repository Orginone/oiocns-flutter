import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ThingPage extends BaseGetView<ThingController, ThingState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.title,
      body: Obx(() {
        return ListView.builder(itemBuilder: (context, index) {
          return Item(item: state.things[index],);
        }, itemCount: state.things.length,);
      }),
    );
  }
}