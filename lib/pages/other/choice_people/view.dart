import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ChoicePeoplePage
    extends BaseGetView<ChoicePeopleController, ChoicePeopleState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: '人员',
      body: SafeArea(
        child: Column(
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
              data = state.selectedGroup.last.subTarget;
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

}
