import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/widget/common_widget.dart';

import '../../../dart/core/getx/base_get_view.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ChoiceAssetsPage
    extends BaseGetView<ChoiceAssetsController, ChoiceAssetsState> {
  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("请选择资产分类"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: XColors.themeColor,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            CommonWidget.commonSearchBarWidget(
                controller: state.searchController,
                onSubmitted: (str) {
                  controller.search(str);
                },
                hint: "请输入资产分类名称"),
            Expanded(child: Obx(() {
              if (state.showSearchPage.value) {
                return search();
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Item(categoryGroup: state.assetsCategory[index]);
                      },
                      itemCount: state.assetsCategory.length,
                    ),
                  ),
                  selectedItem(),
                ],
              );
            })),
          ],
        ),
      ),
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
                  state.selectedAsset.value?.name ?? "",
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

  Widget search(){
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              var item = state.searchList[index];
              return Obx(() {
                return CommonWidget.commonRadioTextWidget(
                    item.name ?? "", item,
                    groupValue: state.selectedAsset.value,
                    onChanged: (v) {
                      controller.selectItem(item);
                    },
                    keyWord: state.searchController.text);
              });
            },
            itemCount: state.searchList.length,
          ),
        ),
        Obx(() {
          return CommonWidget.commonShowChoiceDataInfo(
              state.selectedAsset.value?.name ?? "",
              onTap: () {
                controller.back();
              });
        }),
      ],
    );
  }

}
