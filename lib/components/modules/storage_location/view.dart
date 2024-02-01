import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class StorageLocationPage
    extends BaseGetView<StorageLocationController, StorageLocationState> {
  const StorageLocationPage({super.key});

  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("存放地点"),
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
                hint: "请输入存放地点名称"),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Obx(() {
                if (state.showSearchPage.value) {
                  return search();
                } else {
                  return body();
                }
              }),
            ),
            Obx(() {
              return CommonWidget.commonShowChoiceDataInfo(
                  state.selectedLocation.value?.fullName ?? "", onTap: () {
                controller.back();
              });
            })
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
          return CommonWidget.commonRadioTextWidget(item.placeName ?? "", item,
              groupValue: state.selectedLocation.value, onChanged: (v) {
            controller.selectLocation(item);
          }, keyWord: state.searchController.text);
        });
      },
      itemCount: state.searchList.length,
    );
  }

  Widget body() {
    return Obx(() {
      List<StorageLocation> data = state.mockRx;

      if (state.selectedGroup.isNotEmpty) {
        data = state.selectedGroup.value.last.children!;
      }

      return ListView.builder(
        itemBuilder: (context, index) {
          var item = data[index];
          return Item(
            location: item,
            onTap: () {
              controller.selectLocationGroup(item);
            },
            onChanged: (v) {
              controller.selectLocation(item);
            },
          );
        },
        itemCount: data.length,
      );
    });
  }

  Widget classificationName() {
    TextStyle selectedTextStyle =
        TextStyle(fontSize: 20.sp, color: Colors.black);

    TextStyle unSelectedTextStyle =
        TextStyle(fontSize: 20.sp, color: Colors.grey.shade300);

    Widget level(StorageLocation location) {
      int index = state.selectedGroup.indexOf(location);
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
                  text: "${location.placeName}",
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
                        text: "Home",
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
