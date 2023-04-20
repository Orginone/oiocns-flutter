import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import '../../../widget/unified.dart';
import '../../../dart/core/getx/base_get_view.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class AddAssetPage extends BaseGetView<AddAssetController, AddAssetState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "添加资产",
      body: Column(
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
    );
  }

  Widget searchBar(){
    return  Row(
      children: [
        Expanded(
          child: CommonWidget.commonSearchBarWidget(
            controller: state.searchController,
            hint: "请输入资产名称",
            onChanged: (str) {
              controller.search(str);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          color: Colors.white,
          child: IconButton(
              onPressed: () {
                controller.showFilter();
              },
              icon: const Icon(Icons.filter_list)),
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
          var item =  state.searchList.isNotEmpty?state.searchList[index]:state.selectAssetList[index];
          return Item(
            showChoiceButton: item.notLockStatus,
            assets: item,
            openInfo: () {
              controller.openItem(item);
            },
            changed: (select) {
              controller.selectItem(item);
            },
            onTap: () {
              controller.selectItem(item);
            },
          );
        },
        itemCount: state.searchList.isNotEmpty?state.searchList.length:state.selectAssetList.length,
      );
    });
  }
}
