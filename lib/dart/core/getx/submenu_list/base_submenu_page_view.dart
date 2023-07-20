import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/unified.dart';

import 'base_submenu_controller.dart';
import 'base_submenu_state.dart';

abstract class BaseSubmenuPage<T extends BaseSubmenuController,
S extends BaseSubmenuState> extends BaseGetView<T, S> {


  @override
  Widget buildView() {
    // TODO: implement build
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            flexibleSpace: headWidget(),
            floating: true,
            pinned: true,
            toolbarHeight: 55.h,
          )
        ];
      },
      body: body(),
    );
  }


  Widget headWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return TabBar(
                controller: state.tabController,
                tabs: state.subGroup.value.groups!.map((e) {
                  var index = state.subGroup.value.groups!.indexOf(e);
                  return Tab(
                    height: 40.h,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.w),
                        color: state.submenuIndex.value == index
                            ? XColors.themeColor
                            : Colors.grey[200],
                      ),
                      child: Text(
                        e.label!,
                        style: TextStyle(
                            color: state.submenuIndex.value != index
                                ? XColors.themeColor
                                : Colors.white, fontSize: 18.sp),
                      ),
                    ),
                  );
                }).toList(),
                indicatorColor: XColors.themeColor,
                unselectedLabelColor: Colors.grey,
                labelColor: XColors.themeColor,
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                indicator: const UnderlineTabIndicator(),
              );
            }),
          ),
          IconButton(
            onPressed: () {
              controller.showGrouping();
            },
            alignment: Alignment.center,
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            iconSize: 24.w,
            padding: EdgeInsets.zero,)
        ],
      ),
    );
  }

  Widget body() {
    return NotificationListener<ScrollNotification>(
      onNotification: state.pageViewScrollUtils.handleNotification,
      child: Obx(() {
        var groups = state.subGroup.value.groups!;
        return TabBarView(
          controller: state.tabController,
          children: groups.map((e) => buildPageView(e.value!)).toList(),
        );
      }),
    );
  }

  Widget buildPageView(String type);

  @override
  // TODO: implement showAppBar
  bool get showAppBar => false;

  @override
  // TODO: implement hasNested
  bool get hasNested => true;

  @override
  bool displayNoDataWidget() => false;
}
