import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/mapping_components.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';
import 'state.dart';

class ProcessInfoPage
    extends BaseGetPageView<ProcessInfoController, ProcessInfoState> {
  @override
  Widget buildView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _mainTable(),
                _subTable(),
                SizedBox(
                  height: 10.h,
                ),
                _opinion(),
              ],
            ),
          ),
        ),
        _approval(),
      ],
    );
  }

  Widget _mainTable() {
    return Obx(() {
      if (state.mainForm.isEmpty) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonNonIndicatorTabBar(
              state.mainTabController,
              state.mainForm
                  .map((element) => element.name!)
                  .toList(), onTap: (index) {
            controller.changeMainIndex(index);
          }),
          Column(
            children: state.mainForm[state.mainIndex.value].fields.map((e) {
                  Map<String, dynamic> info = {};
                  if (state.mainForm[state.mainIndex.value].data?.after
                          .isNotEmpty ??
                      false) {
                    info = state.mainForm[state.mainIndex.value].data!.after[0]
                        .otherInfo;
                  }
                  return FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done &&
                          !snapshot.hasData) {
                        return Container();
                      }
                      Widget child = testMappingComponents[e.field.type ?? ""]!(
                          e.field, settingCtrl.user);
                      return child;
                    },
                    future: controller.loadMainFieldData(e, info),
                  );
            }).toList() ??
                [],
          ),
        ],
      );
    });
  }

  Widget _subTable() {
    return Obx(() {
      if(state.subForm.isEmpty){
        return const SizedBox();
      }
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            CommonWidget.commonNonIndicatorTabBar(state.subTabController,
                state.subForm.map((element) => element.name!).toList(),onTap: (index){
              controller.changeSubIndex(index);
                }),
            Obx(() {
              var sub = state.subForm[state.subIndex.value];
              List<String> title =
                  sub.fields.map((e) => e.name ?? "").toList() ?? [];
              return FutureBuilder<List<List<String>>>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CommonWidget.commonDocumentWidget(
                      title: ["标识", "创建者", "状态", ...title],
                      content: snapshot.data ?? [],
                    );
                  }
                  return Container();
                },
                future:
                controller.loadSubFieldData(sub, sub.fields),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _approval() {
    if (state.todo.metadata.status != 1) {
      return Container();
    }
    return Container(
      width: double.infinity,
      height: 100.h,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
          Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5))),
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
              color: XColors.themeColor,
              onTap: () {
                controller.approval(100);
              }),
        ],
      ),
    );
  }

  Widget _opinion() {
    if (state.todo.metadata.status != 1) {
      return Container();
    }
    return CommonWidget.commonTextTile(
      "备注",
      "",
      controller: state.comment,
      hint: "请填写备注信息",
      maxLine: 4,
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
          borderRadius: BorderRadius.circular(8.w),
          border: border,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 24.sp),
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
