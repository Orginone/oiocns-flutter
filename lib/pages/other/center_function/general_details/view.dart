import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/assets_config.dart';

import 'approval_process/view.dart';
import 'details/view.dart';
import 'logic.dart';
import 'state.dart';

class GeneralDetailsPage
    extends BaseGetView<GeneralDetailsController, GeneralDetailsState> {
  @override
  Widget buildView() {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("${state.assetsType.name}详情"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: XColors.themeColor,
      ),
      body: SafeArea(
        child: Column(
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
        KeepAlive(keepAlive: true, child: DetailsPage(state.assetsType)),
        KeepAlive(keepAlive: true, child: ApprovalProcessPage()),
      ],
    );
  }
}
