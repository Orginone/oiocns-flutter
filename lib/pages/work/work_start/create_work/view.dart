import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/work/work_start/create_work/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/load_state_widget.dart';
import 'package:orginone/widget/mapping_components.dart';

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
                  SizedBox(
                    height: 10.h,
                  ),
                  subTable(),
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
    return FutureBuilder(
      future: controller.loadMainTable(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              CommonWidget.commonHeadInfoWidget(
                  state.workForm.value?.name ?? ""),
              ...state.workForm.value?.attributes?.map((e) {
                    if (e.fields?.type == null) {
                      return Container();
                    }
                    Widget child =
                        testMappingComponents[e.fields!.type ?? ""]!(e.fields!,state.target);
                    return child;
                  }).toList() ??
                  [],
            ],
          );
        }
        return SizedBox(
          height: Get.height,
          child: LoadStateWidget(
            isLoading: true,
            isSuccess: false,
          ),
        );
      },
    );
  }

  Widget subTable() {
    return FutureBuilder(
      future: controller.loadSubTable(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonWidget.commonNonIndicatorTabBar(
                          state.tabController,
                          state.thingForm
                              .map((element) => element.name)
                              .toList()),
                    ),
                    CommonWidget.commonPopupMenuButton(
                      items: SubTableEnum.values.map((e) {
                        String label = e.label;
                        if (e != SubTableEnum.allChange && state.thingForm.isNotEmpty) {
                          label = label +
                              state.thingForm[state.tabController.index].name;
                        }
                        return PopupMenuItem(
                          value: e,
                          child: Text(label),
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
                height: 500.h,
                child: Obx(() {
                  return TabBarView(
                    controller: state.tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: state.thingForm.map((element) {
                      List<String> title = element.attributes
                              ?.map((e) => e.name ?? "")
                              .toList() ??
                          [];
                      List<List<String>> content = element.things.map((e) {
                        List<String> data = [];
                        e.eidtInfo!.forEach((key, value) {
                          String v = '';
                          if(value!=null){
                            if(value is Map){
                              v = value.values.first.toString();
                            } else if(value is XTarget || value is FileItemModel){
                              v = value.name;
                            } else{
                              v = value.toString();
                            }
                          }
                          data.add(v);
                        });
                        return [
                          e.id ?? "",
                          e.status ?? "",
                          e.createrName ?? "",
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
          );
        }
        return const SizedBox();
      },
    );
  }
}
