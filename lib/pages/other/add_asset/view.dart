import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/common_widget.dart';

import '../../../components/unified.dart';
import '../../../dart/core/getx/base_get_view.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class AddAssetPage extends BaseGetView<AddAssetController, AddAssetState> {
  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加资产"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: XColors.themeColor,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            searchBar(),
            allSelectButton(),
            Expanded(
              child: list(),
            ),
            CommonWidget.commonSubmitWidget(submit: () {
              controller.submit();
            })
          ],
        ),
      ),
    );
  }

  Widget searchBar(){
    return  Row(
      children: [
        Expanded(child: CommonWidget.commonSearchBarWidget(
            controller: state.searchController, hint: "请输入资产名称")),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          color: Colors.white,
          child: IconButton(onPressed: () {
            controller.showFilter();
          }, icon: const Icon(Icons.filter_list)),
        )
      ],
    );
  }

  Widget allSelectButton(){
    return  Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              return CommonWidget.commonMultipleChoiceButtonWidget(
                  changed: (value) {
                    controller.selectAll(value);
                  }, isSelected: state.selectAll.value);
            }),
            SizedBox(width: 10.w,),
            Obx(() {
              return Text("已选:${state.selectCount.value}",
                style: TextStyle(fontSize: 20.sp),);
            }),
          ],
        )
    );
  }

  Widget list(){
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          return Item(
            showChoiceButton: state.selectAssetList[index].notLockStatus,
            assets: state.selectAssetList[index],
            openInfo: () {
              controller.openItem(index);
            },
            changed: (select) {
              controller.selectItem(index);
            },
            onTap: () {
              controller.selectItem(index);
            },
          );
        },
        itemCount: state.selectAssetList.length,
      );
    });
  }
}
