import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/config/colors.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';

import 'logic.dart';
import 'state.dart';

class StorePage extends BaseGetPageView<StoreController, StoreState> {
  StorePage({super.key});

  @override
  Widget buildView() {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          CommonWidget.commonNonIndicatorTabBar(state.tabController, tabTitle),
          PopularWidget(),
        ],
      ),
    );
  }

  Widget PopularWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "热门应用",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 51, 52, 54)),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.recentlyList.map((value) {
                Widget child = button(value);
                if (state.recentlyList.indexOf(value) !=
                    (state.recentlyList.length - 1)) {
                  child = Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: child,
                  );
                }
                return child;
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget button(Popular recent) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(27.w)),
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(recent.url)),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            recent.name,
            maxLines: 1,
            style: TextStyle(
                fontSize: 14.sp,
                color: const Color.fromARGB(255, 52, 52, 54),
                overflow: TextOverflow.ellipsis
                // color: Colors.black
                ),
          )
        ],
      ),
    );
  }

  @override
  StoreController getController() {
    return StoreController();
  }
}
