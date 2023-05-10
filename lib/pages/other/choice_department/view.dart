import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ChoiceDepartmentPage
    extends BaseGetView<ChoiceDepartmentController, ChoiceDepartmentState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "部门",
      body: Column(
        children: [
          Obx(
                () {
              return CommonWidget.commonBreadcrumbNavWidget(
                firstTitle: '',
                allTitle: state.selectedGroup
                    .map((element) => element.metadata.name)
                    .toList(),
                onTapFirst: () {
                  controller.clearGroup();
                },
                onTapTitle: (index) {
                  controller.removeGroup(index);
                },
              );
            },
          ),
          CommonWidget.commonSearchBarWidget(
              controller: state.searchController,
              onSubmitted: (str) {
                controller.search(str);
              },
              hint: "请输入部门"),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Obx(() {
              if (state.showSearchPage.value) {
                return search();
              }
              return body();
            }),
          ),
          Obx(() {
            return CommonWidget.commonShowChoiceDataInfo(
                state.selectedDepartment.value?.metadata.name ?? "", onTap: () {
              controller.back();
            });
          }),
        ],
      ),
    );
  }

  Widget search() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var item = state.searchList[index];
        return Obx(() {
          return CommonWidget.commonRadioTextWidget(item.metadata.name ?? "", item,
              groupValue: state.selectedDepartment.value, onChanged: (v) {
                controller.selectedDepartment(item);
              }, keyWord: state.searchController.text);
        });
      },
      itemCount: state.searchList.length,
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() {
            var data = state.departments.value;
            if (state.selectedGroup.isNotEmpty) {
              data = state.selectedGroup.last.subTarget;
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = data[index];
                return Obx(() {
                  return Item(
                    choicePeople: item,
                    selected: state.selectedDepartment.value,
                    next: () {
                      controller.selectGroup(item);
                    },
                    onChanged: (v) {
                      controller.selectedDepartment(item);
                    },
                  );
                });
              },
              shrinkWrap: true,
              itemCount: data.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
            );
          }),
        ],
      ),
    );
  }

}