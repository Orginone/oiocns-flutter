import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/setting/cofig.dart';
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
            CommonWidget.commonBreadcrumbNavWidget(
              firstTitle: "关系",
              allTitle: [],
            ),
            Expanded(child: list())
          ],
        ));
  }

  Widget list() {
    return Obx(() {
      if(state.setting.isCompanySpace()){
        return Column(
          children: CompanySpaceEnum.values
              .map((e) =>
              Item(
                companySpaceEnum: e,
                nextLv: () {
                  controller.nextLvForEnum(e);
                },
              ))
              .toList(),
        );
      }else{
        return Container();
      }
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
