import 'package:extended_tabs/extended_tabs.dart';
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
    return Column(
      children: [
        headWidget(),
        Expanded(child: body()),
      ],
    );
  }


  Widget headWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return ExtendedTabBar(
                controller: state.tabController,
                tabs: state.subGroup.value.groups!.map((e) {
                  var index = state.subGroup.value.groups!.indexOf(e);
                  return ExtendedTab(
                    scrollDirection: Axis.horizontal,
                    height: 40.h,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.w),
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
    return Obx(() {
      var groups = state.subGroup.value.groups!;
      return ExtendedTabBarView(
        link: true,
        physics: const ClampingScrollPhysics(),
        controller: state.tabController,
        children: groups.map((e) {
          return SizedBox(
            key: PageStorageKey(state.subGroup.value.type! + e.value!),
            child: buildPageView(e.value!),
          );
        }).toList(),
      );
    });
  }

  Widget buildPageView(String type);

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.child);

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 55;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}