import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ChoiceGbPage extends BaseGetView<ChoiceGbController, ChoiceGbState> {
  @override
  Widget buildView() {
    return GyScaffold(
      centerTitle: false,
       titleWidget: Obx(
             () {
           return CommonWidget.commonBreadcrumbNavWidget(
               firstTitle: state.head,
               allTitle: state.selectedGroup
                   .map((element) => element.name)
                   .toList(),
               onTapFirst: () {
                 controller.back();
               },
               onTapTitle: (index) {
                 controller.removeGroup(index);
               },padding: EdgeInsets.zero);
         },
       ),
      leadingWidth: 0,
      leading: const SizedBox(),
      body: Column(
        children: [
          CommonWidget.commonSearchBarWidget(
              controller: state.searchController,
              onSubmitted: (str) {
                controller.search(str);
              },
              hint: "请输入分类标准名称"),
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
        ],
      ),
    );
  }

  Widget search() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var item = state.searchList[index];
        return Obx(() {
          return GbItem(
            item: item,
            showPopupMenu: state.showPopupMenu,
            next: () {
              if (item.children.isNotEmpty) {
                controller.selectGroup(item);
              }
            },
            onTap: () {
              controller.onTap(item);
            },
          );
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
            var data = state.gb.value;
            if (state.selectedGroup.isNotEmpty) {
              data = state.selectedGroup.last.children;
            }
            return Container(
              margin: EdgeInsets.only(
                  bottom: (data.isNotEmpty) ? 10.h : 0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var item = data[index];
                  return GbItem(
                    item: item,
                    showPopupMenu: state.showPopupMenu,
                    next: () {
                      if (item.children.isNotEmpty) {
                        controller.selectGroup(item);
                      }
                    },
                    onTap: () {
                      controller.onTap(item);
                    },
                  );
                },
                shrinkWrap: true,
                itemCount: data.length,
                physics: const NeverScrollableScrollPhysics(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
