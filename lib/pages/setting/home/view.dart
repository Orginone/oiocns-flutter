import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_page.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class SettingCenterPage
    extends BaseBreadcrumbNavPage<SettingCenterController, SettingCenterState> {

  @override
  Widget body() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: state.spaces
                  .map((e) {
                return BaseBreadcrumbNavItem(
                  item: e,
                  onTap: () {
                    controller.jumpInfo(e);
                  },
                  onNext: () {
                    controller.jumpSetting(e);
                  },
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          child: CommonWidget.commonSubmitWidget(text: "退出登录",submit: (){
            controller.jumpLogin();
          }),
        ),
      ],
    );
  }


}
