import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/work/work_start/create_work/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/mapping_components.dart';

import '../../../../dart/core/consts.dart';
import 'logic.dart';

class CreateWorkPage
    extends BaseGetView<CreateWorkController, CreateWorkState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "创建办事",
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  mainTable(),
                  subTable(),
                  CommonWidget.commonTextTile(
                    "备注",
                    "",
                    controller: state.remark,
                    hint: "请填写备注信息",
                    maxLine: 4,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          CommonWidget.commonSubmitWidget(
              submit: () {
                controller.submit();
              },
              text: "提交"),
        ],
      ),
    );
  }

  Widget mainTable() {
    return Obx(() {
      if (state.mainForm.value == null) {
        return const SizedBox();
      }
      return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            CommonWidget.commonHeadInfoWidget(
                state.mainForm.value?.metadata.name ?? ""),
            ...state.mainForm.value?.fields.map((e) {
                  if (e.field.type == null) {
                    return Container();
                  }
                  Widget child =
                      testMappingComponents[e.field.type ?? ""]!(e.field, state.target);
                  return child;
                }).toList() ??
                [],
          ],
        ),
      );
    });
  }

  Widget subTable() {
    return Obx(() {
      if (state.subForm.isEmpty) {
        return Container();
      }
      return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: CommonWidget.commonNonIndicatorTabBar(
                        state.tabController,
                        state.subForm
                            .map((element) => element.metadata.name!)
                            .toList()),
                  ),
                  CommonWidget.commonPopupMenuButton(
                    items: SubTableEnum.values.map((e) {
                      return PopupMenuItem(
                        value: e,
                        child: Text(e.label),
                      );
                    }).toList(),
                    onSelected: (SubTableEnum function) {
                      controller.subTableOperation(function);
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 300.h,
              child: Obx(() {
                return TabBarView(
                  controller: state.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: state.subForm.map((element) {
                    List<String> title =
                        element.fields.map((e) => e.name ?? "").toList();
                    List<List<String>> content =
                        element.things.map((e) {
                      List<String> data = [];
                      for (var element in element.fields) {
                        data.add(e.otherInfo[element.id]??"");
                      }
                      return [
                        e.id ?? "",
                        e.status ?? "",
                        ShareIdSet[e.creater]?.name??"",
                        ...data
                      ];
                    }).toList();

                    return CommonWidget.commonDocumentWidget(
                        title: ["标识", "创建者", "状态", ...title],
                        content: content,
                        showOperation: true,
                        popupMenus: const [
                          PopupMenuItem(
                            value: "edit",
                            child: Text("编辑"),
                          ),
                          PopupMenuItem(
                            value: "delete",
                            child: Text("删除"),
                          ),
                        ],
                        onOperation: (function, key) {
                          controller.subTableFormOperation(function, key);
                        });
                  }).toList(),
                );
              }),
            )
          ],
        ),
      );
    });
  }
}
