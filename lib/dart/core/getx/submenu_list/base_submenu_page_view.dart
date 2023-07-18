import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';
import 'package:orginone/widget/unified.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'base_submenu_controller.dart';
import 'base_submenu_state.dart';
import 'item.dart';

abstract class BaseSubmenuPage<T extends BaseSubmenuController,
S extends BaseSubmenuState> extends BaseGetListView<T, S> {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            flexibleSpace: headWidget(),
            floating: true,
            pinned: true,
            elevation: 0,
            toolbarHeight: 55.h,
          )
        ];
      },
      body: super.build(context),
    );
  }


  Widget headWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return ScrollablePositionedList.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                scrollDirection: Axis.horizontal,
                itemCount: state.subGroup.value.groups!.length,
                itemBuilder: (BuildContext context, int index) {
                  var menu = state.subGroup.value.groups![index];
                  return Obx(() {
                    return GestureDetector(
                      onTap: () {
                        controller.changeSubmenuIndex(index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 15.w),
                        margin: EdgeInsets.only(
                            right: index !=
                                state.subGroup.value.groups!.length - 1
                                ? 10.w
                                : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.w),
                          color: state.submenuIndex.value == index
                              ? XColors.themeColor
                              : Colors.grey[200],
                        ),
                        child: Text(
                          menu.label!,
                          style: TextStyle(
                              color: state.submenuIndex.value != index
                                  ? XColors.themeColor
                                  : Colors.white, fontSize: 18.sp),
                        ),
                      ),
                    );
                  });
                },
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

  @override
  Widget buildView() {
    return Obx(() {
     var groups = state.subGroup.value.groups!;
      return PageView.builder(
        itemBuilder: (context, index) {
          var type = groups[index].value;
          return IntrinsicHeight(child: buildPageView(type!));
        },
        itemCount: groups.length,
        physics: const NeverScrollableScrollPhysics(),
        controller: state.pageController,
      );
    });
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
