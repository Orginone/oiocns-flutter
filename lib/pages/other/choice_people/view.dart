import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/widget/common_widget.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ChoicePeoplePage
    extends BaseGetView<ChoicePeopleController, ChoicePeopleState> {
  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("人员"),
        centerTitle: true,
        backgroundColor: XColors.themeColor,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            classificationName(),
            CommonWidget.commonSearchBarWidget(
                controller: state.searchController,
                onSubmitted: (str) {
                  controller.search(str);
                },
                hint: "请输入姓名"),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Obx(() {
                if(state.showSearchPage.value){
                  return search();
                }
                return body();
              }),
            ),
            Obx(() {
              return CommonWidget.commonShowChoiceDataInfo(
                  state.selectedUser.value?.name ?? "",onTap: (){
                    controller.back();
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget search() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var item = state.searchList[index];
        return Obx(() {
          return CommonWidget.commonRadioTextWidget(item.name ?? "", item,
              groupValue: state.selectedUser.value, onChanged: (v) {
                controller.selectedUser(item);
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
              data = state.selectedGroup.last.subTeam;
            }
            return Container(
              margin: EdgeInsets.only(
                  bottom: (data.isNotEmpty ?? false) ? 10.h : 0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var item = data[index];
                  return GroupItem(
                    department: item,
                    onTap: () {
                      controller.selectGroup(item);
                    },
                  );
                },
                shrinkWrap: true,
                itemCount: data.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
              ),
            );
          }),
          Obx(() {
            var data = [];
            if (state.selectedGroup.isNotEmpty) {
              data = state.selectedGroup.last.members;
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = data[index];
                return PeopleItem(
                  people: item,
                  onChanged: (v) {
                    controller.selectedUser(item);
                  },
                );
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

  Widget classificationName() {
    TextStyle selectedTextStyle =
    TextStyle(fontSize: 20.sp, color: Colors.black);

    TextStyle unSelectedTextStyle =
    TextStyle(fontSize: 20.sp, color: Colors.grey.shade300);

    Widget level(ITarget department) {
      int index = state.selectedGroup.indexOf(department);
      return GestureDetector(
        onTap: () {
          controller.removeGroup(index);
        },
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                  child: Icon(
                    Icons.chevron_right,
                    size: 32.w,
                  ),
                  alignment: PlaceholderAlignment.middle),
              TextSpan(
                  text: department.name,
                  style: index == state.selectedGroup.length - 1
                      ? selectedTextStyle
                      : unSelectedTextStyle),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Obx(() {
        List<Widget> nextStep = [];
        if (state.selectedGroup.isNotEmpty) {
          for (var value in state.selectedGroup) {
            nextStep.add(level(value));
          }
        }
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.clearGroup();
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                        child: Container(
                          width: 5.w,
                          height: 25.h,
                          margin: EdgeInsets.only(right: 15.w),
                          color: XColors.themeColor,
                        ),
                        alignment: PlaceholderAlignment.middle),
                    TextSpan(
                        text: DepartmentManagement().getCurrentCompanyName(),
                        style: state.selectedGroup.isEmpty
                            ? selectedTextStyle
                            : unSelectedTextStyle)
                  ],
                ),
              ),
            ),
            ...nextStep,
          ],
        );
      }),
    );
  }
}