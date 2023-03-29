import 'package:flutter/material.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/other/work/initiate/initiate_business/view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'have_initiated/view.dart';
import 'logic.dart';
import 'state.dart';

class InitiatePage extends BaseGetPageView<InitiateController, InitiateState> {
  @override
  Widget buildView() {
    return Container(
      color: GYColors.backgroundColor,
      child: Column(
        children: [
          CommonWidget.commonNonIndicatorTabBar(state.tabController, tabTitle),
          Expanded(
            child: TabBarView(
              controller: state.tabController,
              children: [
                KeepAliveWidget(
                  child: InitiateBusinessPage(),
                ),
                Container(),
                KeepAliveWidget(child:HaveInitiatedPage()),
                Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  InitiateController getController() {
    return InitiateController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "Initiate";
  }
}
