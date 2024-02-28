import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';

import 'logic.dart';
import 'state.dart';

class CreateWorkPage
    extends BaseGetView<CreateWorkController, CreateWorkState> {
  const CreateWorkPage({super.key});

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
      if (state.mainForm.isEmpty) {
        return const SizedBox();
      }
      return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            CommonWidget.commonNonIndicatorTabBar(
                state.mainTabController,
                state.mainForm
                    .map((element) => element.metadata.name!)
                    .toList(), onTap: (index) {
              controller.changeMainIndex(index);
            }, labelStyle: TextStyle(fontSize: 20.sp)),
            Column(
              children: state.mainForm[state.mainIndex.value].fields.map((e) {
                    if (e.field.type == null) {
                      return Container();
                    }
                    Widget child = mappingComponents[e.field.type ?? ""]!(
                        e.field, state.target);
                    return child;
                  }).toList() ??
                  [],
            ),
          ],
        ),
      );
    });
  }

  Widget subTable() {
    return Obx(() {
      if (state.subForm.isEmpty) {
        return const SizedBox();
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
                        state.subTabController,
                        state.subForm
                            .map((element) => element.metadata.name!)
                            .toList(), onTap: (index) {
                      controller.changeSubIndex(index);
                    }, labelStyle: TextStyle(fontSize: 20.sp)),
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
            Builder(builder: (context) {
              var sub = state.subForm[state.subIndex.value];
              List<String> title = sub.fields.map((e) => e.name ?? "").toList();

              return FutureBuilder<List<List<String>>>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CommonWidget.commonDocumentWidget(
                        title: ["唯一标识", "创建者", "状态", ...title],
                        content: snapshot.data ?? [],
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
                  }
                  return Container();
                },
                future: controller.loadSubFieldData(sub, sub.fields),
              );
            }),
          ],
        ),
      );
    });
  }
}
