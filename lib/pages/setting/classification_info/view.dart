import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/keep_alive_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'attrs.dart';
import 'basic_info.dart';
import 'form.dart';
import 'logic.dart';
import 'person_info.dart';
import 'property.dart';
import 'species.dart';
import 'state.dart';
import 'work.dart';


class ClassificationInfoPage
    extends BaseGetView<ClassificationInfoController, ClassificationInfoState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.data.name??"",
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
                    return BasicInfo(
                      data: state.species?.metadata,
                    );
                  case ClassificationEnum.personInfo:
                    return PersonInfo(
                      data: state.species,
                    );
                  case ClassificationEnum.property:
                    return KeepAliveWidget(child: PropertyPage());
                  case ClassificationEnum.attrs:
                    return KeepAliveWidget(child: AttrsPage());
                  case ClassificationEnum.form:
                    return KeepAliveWidget(child: FormPage());
                  case ClassificationEnum.work:
                    return KeepAliveWidget(child: WorkPage());
                  case ClassificationEnum.species:
                    return KeepAliveWidget(child: SpeciesPage());
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
            var classif = state.tabTitle[state.currentIndex.value];
            if (state.currentIndex.value == 0 ||  classif == ClassificationEnum.form || classif == ClassificationEnum.attrs) {
              return Container();
            }

            return CommonWidget.commonPopupMenuButton(items: [
              PopupMenuItem(
                value: 'create',
                  child: Text(
                      "新增${state.species.metadata.typeName}"),
                ),
            ], onSelected: (str) {
              controller.create(state.tabTitle[state.currentIndex.value]);
              },);
          }),
        ],
      ),
    );
  }
}