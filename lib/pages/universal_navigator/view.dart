import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class UniversalNavigatorPage
    extends BaseGetView<UniversalNavigatorController, UniversalNavigatorState> {
  @override
  Widget buildView() {
    return GyScaffold(
        centerTitle: false,
        titleWidget: Obx(
              () {
            return CommonWidget.commonBreadcrumbNavWidget(
                firstTitle: state.title,
                allTitle: state.selectedData.map((element) => element.title)
                    .toList(),
                onTapFirst: () {
                  controller.back();
                },
                onTapTitle: (index) {
                  controller.removeGroup(index);
                },
                padding: EdgeInsets.zero);
          },
        ),
        leadingWidth: 0,
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        body: Obx(() {
          var data = state.sourceData.value;
          if (state.selectedData.isNotEmpty) {
            data = state.selectedData.last.children;
          }
          return Container(
            margin: EdgeInsets.only(
                bottom: (data.isNotEmpty) ? 10.h : 0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                var item = data[index];
                return NavigatorItem(
                  item: item,
                  onTap: (){
                    controller.selectItem(item);
                  },
                  next: (){
                    controller.selectGroup(item);
                  },
                  popupMenuItem: state.popupMenuItem,
                  action: state.action,
                );
              },
              shrinkWrap: true,
              itemCount: data.length,
              physics: const NeverScrollableScrollPhysics(),
            ),
          );
        }),
    );
  }
}
