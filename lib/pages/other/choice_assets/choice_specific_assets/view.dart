import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/choice_assets/logic.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class ChoiceSpecificAssetsPage extends BaseGetView<
    ChoiceSpecificAssetsController,
    ChoiceSpecificAssetsState> {

  ChoiceAssetsController get choiceAssetController =>
      Get.find<ChoiceAssetsController>();

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.selectedCategory.name,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () {
                bool verification =
                    state.selectedSecondLevelAsset.value != null &&
                        (state.selectedSecondLevelAsset.value!.nextLevel
                            .isNotEmpty);
                return CommonWidget.commonBreadcrumbNavWidget(
                  firstTitle: state.selectedCategory.name,
                  allTitle: verification
                      ? [state.selectedSecondLevelAsset.value!.name]
                      : [],
                  onTapFirst: () {
                    controller.previousStep();
                  },
                );
              },
            ),
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


  Widget listView() {
    if (!state.selectedCategory.hasNextLevel) {
      return ListView.builder(
        itemBuilder: (context, index) {
          var item = state.selectedCategory.nextLevel[index];
          return Obx(() {
            return CommonWidget.commonRadioTextWidget(
                item.name ?? "", item,
                groupValue: choiceAssetController.state.selectedAsset.value,
                onChanged: (i) {
                  controller.selectItem(item);
                });
          });
        },
        itemCount: state.selectedCategory.nextLevel.length,
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
                var item = state.selectedCategory.nextLevel[index];
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
                        item.name ?? '',
                        style: TextStyle(
                            color: state.selectedChildIndex.value == index
                                ? XColors.themeColor
                                : Colors.black),
                      ),
                    ),
                  );
                });
              },
              itemCount: state.selectedCategory.nextLevel
                  .length,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
            child: Obx(() {
              var category=state
                  .selectedCategory
                  .nextLevel[state.selectedChildIndex.value];
              if(!category.hasNextLevel){
                category.nextLevel.add(AssetsCategoryGroup.formJson(category.toJson()));
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  AssetsCategoryGroup  item = state
                      .selectedCategory
                      .nextLevel[state.selectedChildIndex.value]
                      .nextLevel[index];

                  if (!item.hasNextLevel) {
                    return Obx(() {
                      return CommonWidget.commonRadioTextWidget(
                          item.name, item,
                          groupValue: choiceAssetController.state.selectedAsset
                              .value, onChanged: (i) {
                        controller.selectItem(item);
                      });
                    });
                  }
                  return GestureDetector(
                    onTap: () {
                      controller.selectLevelItem(state.selectedCategory
                          .nextLevel[state.selectedChildIndex.value], index);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 70.h,
                      alignment: Alignment.center,
                      child: Text(
                        item.name ?? "",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  );
                },
                itemCount: state
                    .selectedCategory
                    .nextLevel[state.selectedChildIndex.value]
                    .nextLevel
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
        .nextLevel[state.selectedSecondLevelChildIndex.value]
        .nextLevel
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
                    .selectedCategory
                    .nextLevel[state.selectedChildIndex.value]
                    .nextLevel[index];
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
                        item.name ?? '',
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
              itemCount: state.selectedCategory
                  .nextLevel[state.selectedChildIndex.value].nextLevel.length,
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
                  AssetsCategoryGroup item;

                  if (assetLength == 0) {
                    item = state.selectedSecondLevelAsset.value!
                        .nextLevel[state.selectedSecondLevelChildIndex.value];
                  } else {
                    item = state
                        .selectedSecondLevelAsset
                        .value!
                        .nextLevel[state.selectedSecondLevelChildIndex.value]
                        .nextLevel[index];
                  }

                  return Obx(() {
                    return CommonWidget.commonRadioTextWidget(
                        item.name, item,
                        groupValue: choiceAssetController.state.selectedAsset
                            .value, onChanged: (i) {
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
                  choiceAssetController.state.selectedAsset.value?.name ?? "",
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
