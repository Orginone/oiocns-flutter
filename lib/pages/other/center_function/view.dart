import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(state.info.name),
        backgroundColor: XColors.themeColor,
        elevation: 0,
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
    if(state.info.type == AssetsType.check){
      return AssetsPage(AssetsListType.check, state.info.type);
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
    if(state.info.type == AssetsType.check){
      return Container();
    }
    return Container(
      color: XColors.themeColor,
      child: TabBar(
          controller: state.tabController,
          tabs: state.tabTitle
              .map((e) => Tab(
                    text: e,
                  ))
              .toList(),
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle:
              TextStyle(fontSize: 21.sp, color: Colors.grey),
          labelStyle: TextStyle(fontSize: 21.sp, color: Colors.white)),
    );
  }
}
