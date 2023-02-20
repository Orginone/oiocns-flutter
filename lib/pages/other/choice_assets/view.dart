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
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Item(
                    childList: state.mockList[index],
                  );
                },
                itemCount: state.mockList.length,
              );
            })),
          ],
        ),
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
                    item.categoryName ?? "", item,
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
              state.selectedAsset.value?.categoryName ?? "",
              onTap: () {
                controller.back();
              });
        }),
      ],
    );
  }

}
