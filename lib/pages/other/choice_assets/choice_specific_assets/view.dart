import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/choice_assets/logic.dart';
import 'package:orginone/widget/common_widget.dart';

import '../state.dart';
import 'logic.dart';
import 'state.dart';

class ChoiceSpecificAssetsPage extends BaseGetView<
    ChoiceSpecificAssetsController,
    ChoiceSpecificAssetsState> {

  ChoiceAssetsController get choiceAssetController => Get.find<ChoiceAssetsController>();

  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: Text("${state.selectedMock.categoryName}"),
        centerTitle: true,
        backgroundColor: XColors.themeColor,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            classificationName(),
            SizedBox(
              height: 10.h,
            ),
            CommonWidget.commonSearchBarWidget(
                controller: state.searchController,
                onSubmitted: (str) {
                  controller.search(str);
                },
                hint: "请输入资产分类名称",
                showLine: true),
            Expanded(
              child: Obx(() {
                if (state.selectedSecondLevelAsset.value != null) {
                  return secondLevelList();
                }
                return listView();
              }),
            ),
            selectedItem(),
          ],
        ),
      ),
    );
  }

  Widget classificationName() {
    if (choiceAssetController.state.selectedAsset.value?.childList?.isEmpty ?? false) {
      return Container();
    }
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Obx(() {
        Widget nextStep = Container();
        bool verification = state.selectedSecondLevelAsset.value != null &&
            (state.selectedSecondLevelAsset.value!.childList?.isNotEmpty ??
                false);

        TextStyle selectedTextStyle =
        TextStyle(fontSize: 20.sp, color: Colors.black);

        TextStyle unSelectedTextStyle =
        TextStyle(fontSize: 20.sp, color: Colors.grey.shade300);
        if (verification) {
          nextStep = Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                    child: Icon(
                      Icons.chevron_right,
                      size: 32.w,
                    ),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(
                    text:
                    "${state.selectedSecondLevelAsset.value!.categoryName}",
                    style: selectedTextStyle),
              ],
            ),
          );
        }
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.previousStep();
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
                        text: "${state.selectedMock.categoryName}",
                        style: verification
                            ? unSelectedTextStyle
                            : selectedTextStyle)
                  ],
                ),
              ),
            ),
            nextStep,
          ],
        );
      }),
    );
  }

  Widget listView() {
    if (state.selectedMock.isAllLast()) {
      return ListView.builder(
        itemBuilder: (context, index) {
          var item = state.selectedMock.childList![index];
          return Obx(() {
            return CommonWidget.commonRadioTextWidget(
                item.categoryName ?? "", item,
                groupValue: choiceAssetController.state.selectedAsset.value, onChanged: (i) {
              controller.selectItem(item);
            });
          });
        },
        itemCount: state.selectedMock.childList!.length,
      );
    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue.shade50,
            child: ListView.builder(
              itemBuilder: (context, index) {
                var item = state.selectedMock.childList![index];
                return Obx(() {
                  return GestureDetector(
                    onTap: () {
                      controller.changeChildIndex(index);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 70.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: state.selectedChildIndex.value == index
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Text(
                        item.categoryName ?? '',
                        style: TextStyle(
                            color: state.selectedChildIndex.value == index
                                ? XColors.themeColor
                                : Colors.black),
                      ),
                    ),
                  );
                });
              },
              itemCount: state.selectedMock.childList!.length,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
            child: Obx(() {
              return ListView.builder(
                itemBuilder: (context, index) {
                  var item = state
                      .selectedMock
                      .childList![state.selectedChildIndex.value]
                      .childList![index];
                  if (state
                      .selectedMock.childList![state.selectedChildIndex.value]
                      .isAllLast()) {
                    return CommonWidget.commonRadioTextWidget(
                        item.categoryName ?? "", item,
                        groupValue: choiceAssetController.state.selectedAsset.value, onChanged: (i) {
                      controller.selectItem(item);
                    });
                  }
                  return GestureDetector(
                    onTap: () {
                      controller.selectLevelItem(state.selectedMock
                          .childList![state.selectedChildIndex.value],index);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 70.h,
                      alignment: Alignment.center,
                      child: Text(
                        item.categoryName ?? "",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  );
                },
                itemCount: state
                    .selectedMock
                    .childList![state.selectedChildIndex.value]
                    .childList!
                    .length,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget secondLevelList() {
    int assetLength = state
        .selectedSecondLevelAsset
        .value!
        .childList![state.selectedSecondLevelChildIndex.value]
        .childList!
        .length;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue.shade50,
            child: ListView.builder(
              itemBuilder: (context, index) {
                var item = state
                    .selectedMock
                    .childList![state.selectedChildIndex.value]
                    .childList![index];
                return Obx(() {
                  return GestureDetector(
                    onTap: () {
                      controller.changeSecondLevelChildIndex(index);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 70.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                        state.selectedSecondLevelChildIndex.value == index
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Text(
                        item.categoryName ?? '',
                        style: TextStyle(
                            color: state.selectedSecondLevelChildIndex.value ==
                                index
                                ? XColors.themeColor
                                : Colors.black,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  );
                });
              },
              itemCount: state.selectedMock
                  .childList![state.selectedChildIndex.value].childList!.length,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
            child: Obx(() {
              return ListView.builder(
                itemBuilder: (context, index) {
                  ChildList item;

                  if (assetLength == 0) {
                    item = state.selectedSecondLevelAsset.value!
                        .childList![state.selectedSecondLevelChildIndex.value];
                  } else {
                    item = state
                        .selectedSecondLevelAsset
                        .value!
                        .childList![state.selectedSecondLevelChildIndex.value]
                        .childList![index];
                  }

                  return Obx(() {
                    return CommonWidget.commonRadioTextWidget(
                        item.categoryName ?? "", item,
                        groupValue: choiceAssetController.state.selectedAsset.value, onChanged: (i) {
                      controller.selectItem(item);
                    });
                  });
                },
                itemCount: assetLength == 0 ? 1 : assetLength,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget selectedItem() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "已选择:",
                style: TextStyle(color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 5.h,
              ),
              Obx(() {
                return Text(
                  choiceAssetController.state.selectedAsset.value?.categoryName ?? "",
                  style: TextStyle(
                      color: XColors.themeColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700),
                );
              }),
            ],
          ),
          GestureDetector(
            onTap: () {
              controller.back();
            },
            child: Container(
              width: 150.w,
              height: 50.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: XColors.themeColor,
                  borderRadius: BorderRadius.circular(4.w)),
              child: Text(
                "确定",
                style: TextStyle(color: Colors.white, fontSize: 22.sp),
              ),
            ),
          )
        ],
      ),
    );
  }
}
