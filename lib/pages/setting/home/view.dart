import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/widget/common_widget.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class SettingCenterPage
    extends BaseGetPageView<SettingCenterController, SettingCenterState> {
  @override
  Widget buildView() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            tabBar(),
            Obx(() {
              return CommonWidget.commonBreadcrumbNavWidget(
                  firstTitle: "关系",
                  allTitle: state.selectedGroup.value,
                  onTapFirst: () {
                    controller.clearGroup();
                  },
                  onTapTitle: (index) {
                    controller.removeGroup(index);
                  });
            }),
            Expanded(child: list())
          ],
        ));
  }

  Widget list() {
    return Obx(() {
      if(state.groupData.value!=null){
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
           var e = CompanySpaceEnum.findEnum(controller.getGroupName());
           var item = state.groupData.value[index];
           switch(e){
             case CompanySpaceEnum.innerAgency:
             return Item(innerAgency: item,);
             case CompanySpaceEnum.outAgency:
               return Item(outAgency: item,);
             case CompanySpaceEnum.stationSetting:
               return Item(station: item,);
             case CompanySpaceEnum.companyCohort:
               return Item(cohort: item,);
           }
          },
          itemCount: state.groupData.value.length??0,
        );
      }
      return Column(
          children: CompanySpaceEnum.values
              .map((e) =>
              Item(
                companySpaceEnum: e,
              ))
              .toList());
    });
  }



  Widget tabBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: state.tabController,
        tabs: tabTitle.map((e) {
          return Tab(
            text: e,
            height: 60.h,
          );
        }).toList(),
        indicatorColor: XColors.themeColor,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 21.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 23.sp),
      ),
    );
  }

  @override
  SettingCenterController getController() {
    return SettingCenterController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return 'SettingCenter';
  }
}
