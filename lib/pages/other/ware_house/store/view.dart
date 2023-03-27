import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';


class StorePage extends BaseGetPageView<StoreController,StoreState>{
  @override
  Widget buildView() {
    return Container(
      color: GYColors.backgroundColor,
      child: Column(
        children: [
          CommonWidget.commonNonIndicatorTabBar(state.tabController, tabTitle),
        ],
      ),
    );
  }

  @override
  StoreController getController() {
    return StoreController();
  }
}