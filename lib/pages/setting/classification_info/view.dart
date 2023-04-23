import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/classification_info/classification_basic_info.dart';
import 'package:orginone/pages/setting/classification_info/classification_form.dart';
import 'package:orginone/pages/setting/classification_info/classification_work.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'classification_attrs.dart';
import 'logic.dart';
import 'state.dart';


class ClassificationInfoPage
    extends BaseGetView<ClassificationInfoController, ClassificationInfoState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.species.name,
      body: Column(
        children: [
          tabBar(),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: state.tabController,
              children: state.tabTitle.map((e) {
                switch (e) {
                  case ClassificationEnum.info:
                    return ClassificationBasicInfo(
                      species: state.species,
                    );
                  case ClassificationEnum.attrs:
                    return ClassificationAttrs(
                      species: state.species,
                    );
                  case ClassificationEnum.form:
                    return ClassificationForm(
                      species: state.species,
                    );
                  case ClassificationEnum.work:
                    return ClassificationWork(
                      species: state.species,
                    );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: state.tabController,
              tabs: state.tabTitle.map((e) {
                return Tab(
                  text: e.label,
                  height: 40.h,
                );
              }).toList(),
              indicatorColor: XColors.themeColor,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(fontSize: 18.sp),
              labelColor: XColors.themeColor,
              labelStyle: TextStyle(fontSize: 21.sp),
              isScrollable: true,
              onTap: (index) {
                controller.changeIndex(index);
              },
            ),
          ),
          Obx(() {
            if(state.currentIndex.value == 0){
              return Container();
            }
            String text = state.currentIndex.value == 1?'新增特性':state.currentIndex.value == 2?"新增表单":"新增办事";

            return CommonWidget.commonPopupMenuButton(items: [
              PopupMenuItem(
                value: 'create',
                child: Text(text),
              ),
            ], onSelected: (str) {
              controller.create();
            },);
          }),
        ],
      ),
    );
  }
}