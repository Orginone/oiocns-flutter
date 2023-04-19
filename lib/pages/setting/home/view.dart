import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/universal_navigator/item.dart';
import 'package:orginone/pages/universal_navigator/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class SettingCenterPage
    extends BaseGetView<SettingCenterController, SettingCenterState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "设置",
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: state.spaces
              .map(
                (e) => NavigatorItem(
              item: NavigatorModel(title: e.teamName),
              onTap: () {
                controller.jumpInfo(e);
              },
              next: (){
                controller.jumpSetting(e);
              },
            ),
          )
              .toList(),
        ),
      ),
      bottomNavigationBar:  SizedBox(
        height: 140.h,
        child: CommonWidget.commonSubmitWidget(text: "退出登录",submit: (){
          controller.jumpLogin();
        }),
      ),
    );
  }


}
