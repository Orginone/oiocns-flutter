import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/relation/about/about_info/logic.dart';
import 'package:orginone/pages/relation/about/about_info/state.dart';

class VersionInfoPage
    extends BaseGetView<VersionInfoController, VersionInfoState> {
  const VersionInfoPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: '关于奥集能',
        backgroundColor: Colors.white,
        body: Obx(() {
          if (state.mk.isNotEmpty) {
            return Markdown(
              controller: ScrollController(),
              selectable: false,
              data: state.mk.value,
            );
          } else {
            return Container();
          }
        }));
  }
}
