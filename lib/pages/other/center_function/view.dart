import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import '../assets_config.dart';
import 'approval_list/view.dart';
import 'assets_page/view.dart';
import 'logic.dart';
import 'state.dart';

class CenterFunctionPage
    extends BaseGetView<CenterFunctionController, CenterFunctionState> {
  @override
  Widget buildView() {
    List<Widget> actions = [];
    if (state.info.type == AssetsType.myAssets) {
      actions.add(CommonWidget.commonIconButtonWidget(
          iconPath: Images.qrScanIcon,
          callback: () {
            controller.qrScan();
          }));
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(state.info.name),
        backgroundColor: XColors.themeColor,
        centerTitle: true,
        elevation: 0,
        actions: actions,
      ),
      body: Column(
        children: [
          tabBar(),
          Expanded(
            child:body(),
          )
        ],
      ),
    );
  }


  Widget body(){
    if (state.info.type == AssetsType.check) {
      return AssetsPage(AssetsListType.check, state.info.type);
    }
    if (state.info.type == AssetsType.myAssets) {
      return AssetsPage(AssetsListType.myAssets, state.info.type);
    }
    return TabBarView(
      controller: state.tabController,
      children: getTabView(),
    );
  }

  List<Widget> getTabView() {
    switch (state.info.type) {
      case AssetsType.myAssets:
        return [
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.myAssets, state.info.type)),
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.myGoods, state.info.type)),
        ];
      case AssetsType.approve:
        return [
          KeepAliveWidget(child: ApprovalListPage(0)),
          KeepAliveWidget(child: ApprovalListPage(1)),
        ];
      case AssetsType.claim:
        // TODO: Handle this case.
        return [
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.draft, state.info.type)),
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.submitted, state.info.type)),
          KeepAliveWidget(
            child: AssetsPage(AssetsListType.approved, state.info.type),
          ),
        ];
      case AssetsType.transfer:
        return [
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.draft, state.info.type)),
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.submitted, state.info.type)),
          KeepAliveWidget(
            child: AssetsPage(AssetsListType.approved, state.info.type),
          ),
        ];
      case AssetsType.dispose:
        return [
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.draft, state.info.type)),
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.submitted, state.info.type)),
          KeepAliveWidget(
            child: AssetsPage(AssetsListType.approved, state.info.type),
          ),
        ];
      case AssetsType.handOver:
        return [
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.draft, state.info.type)),
          KeepAliveWidget(
              child: AssetsPage(AssetsListType.submitted, state.info.type)),
          KeepAliveWidget(
            child: AssetsPage(AssetsListType.approved, state.info.type),
          ),
        ];
    }

    return [];
  }

  Widget tabBar() {
    if (state.info.type == AssetsType.check ||
        state.info.type == AssetsType.myAssets) {
      return Container();
    }
    return Container(
      color: XColors.themeColor,
      padding: EdgeInsets.only(bottom: 10.h),
      child: TabBar(
          controller: state.tabController,
          tabs: state.tabTitle.map((e) {
            return Tab(
              text: e,
              height: 40.h,
            );
          }).toList(),
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle:
              TextStyle(fontSize: 21.sp, color: Colors.grey),
          labelStyle: TextStyle(fontSize: 21.sp, color: Colors.white)),
    );
  }
}
