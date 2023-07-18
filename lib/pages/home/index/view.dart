import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'state.dart';
import 'package:orginone/widget/keep_alive_widget.dart';
import 'package:orginone/widget/unified.dart';
import 'logic.dart';

class IndexPage extends BaseGetPageView<IndexController,IndexState>{
  @override
  Widget buildView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: tabTitle.map((e){
              return KeepAliveWidget(
                child: Container(),
              );
            }).toList(),
          ),
        )
      ],
    );
  }


  Widget tabBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: state.tabController,
              tabs: tabTitle.map((e) {
                return Tab(
                  text: e,
                  height: 40.h,
                );
              }).toList(),
              indicatorColor: XColors.themeColor,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(fontSize: 18.sp),
              labelColor: XColors.themeColor,
              labelStyle: TextStyle(fontSize: 21.sp),
              isScrollable: true,
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {},
        //   child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Icon(
        //         Icons.more_vert,
        //       )),
        // ),
      ],
    );
  }

  @override
  IndexController getController() {
   return IndexController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return 'index';
  }
}