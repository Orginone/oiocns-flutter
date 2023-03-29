import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'approval_process/view.dart';
import 'details/view.dart';
import 'logic.dart';
import 'state.dart';

class GeneralDetailsPage
    extends BaseGetView<GeneralDetailsController, GeneralDetailsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "${state.assetsType.name}详情",
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: XColors.themeColor,
            child: tabBar(),
          ),
          Expanded(
            child: body(),
          )
        ],
      ),
    );
  }

  Widget tabBar() {
    if(state.assetsType == AssetsType.check){
      return Container();
    }
    return Container(
      color: XColors.themeColor,
      child: Column(
        children: [
          TabBar(
              controller: state.tabController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              tabs: AssetsDetailsTabTitle
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelStyle:
                  TextStyle(fontSize: 21.sp, color: Colors.grey),
              labelStyle: TextStyle(fontSize: 21.sp, color: Colors.white)),
        ],
      ),
    );
  }

  Widget body(){
    if(state.assetsType == AssetsType.check){
      return DetailsPage(state.assetsType);
    }
    return TabBarView(
      controller: state.tabController,
      children: [
        KeepAliveWidget(child: DetailsPage(state.assetsType)),
        KeepAliveWidget(child: ApprovalProcessPage()),
      ],
    );
  }
}
