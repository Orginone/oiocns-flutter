import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ChoiceGbPage extends BaseGetView<ChoiceGbController, ChoiceGbState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "分类标准",
      body: Column(
        children: [
          classificationName(),
          state.showSearch?CommonWidget.commonSearchBarWidget(
              controller: state.searchController,
              onSubmitted: (str) {
                controller.search(str);
              },
              hint: "请输入分类标准名称"):const SizedBox(),
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
          !state.showChoice?const SizedBox():Obx(() {
            return CommonWidget.commonShowChoiceDataInfo(
                state.selectedGb.value?.name ?? "", onTap: () {
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
          return CommonWidget.commonRadioTextWidget(item.name ?? "", item,
              groupValue: state.selectedGb.value, onChanged: (v) {
                controller.selectedGb(item);
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
                  return Obx(() {
                    return Item(
                      showChoice: state.showChoice,
                      showFunctionButton: state.showFunctionButton,
                      item: item,
                      selected: state.selectedGb.value,
                      next: () {
                        if(item.children.isNotEmpty){
                          controller.selectGroup(item);
                        }
                      },
                      onChanged: (value) {
                        controller.selectedGb(item);
                      }, functionMenu: state.menu,
                    );
                  });
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

  Widget classificationName() {
    TextStyle selectedTextStyle =
    TextStyle(fontSize: 20.sp, color: Colors.black);

    TextStyle unSelectedTextStyle =
    TextStyle(fontSize: 20.sp, color: Colors.grey.shade300);

    Widget level(ISpeciesItem group) {
      int index = state.selectedGroup.indexOf(group);
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
                  text: group.name,
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
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
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
                          text: state.head,
                          style: state.selectedGroup.isEmpty
                              ? selectedTextStyle
                              : unSelectedTextStyle)
                    ],
                  ),
                ),
              ),
              ...nextStep,
            ],
          ),
        );
      }),
    );
  }
}
