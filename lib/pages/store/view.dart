import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/unified.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class StorePage extends BaseGetPageView<StoreController, StoreState> {
  @override
  Widget buildView() {
    return Container(
      color: XColors.bgColor,
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return recentlyOpened();
          }
          if (index == 1) {
            return content();
          }
          return StoreItem();
        },
        itemCount: 12,
      ),
    );
  }

  Widget recentlyOpened() {
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
                  "常用",
                  style: XFonts.size24Black0,
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
                int index = state.recentlyList.indexOf(value);

                if (index != (state.recentlyList.length - 1)) {
                  child = Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: child,
                  );
                }
                return Container(
                  margin: EdgeInsets.only(left: index == 0 ? 0 : 27),
                  child: child,
                );
                ;
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget button(Recent recent) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60.w,
            width: 60.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF17BC84),
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Icon(
              Icons.other_houses,
              color: Colors.white,
              size: 48.w,
            ),
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

  Widget content() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "最近打开",
            style: XFonts.size18Black0,
          ),
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: 'time',
                child: Text('筛选'),
              )
            ],
            style: XFonts.size18Black0,
            onChanged: (String? value) {},
            value: "time",
            underline: const SizedBox(),
            icon: Icon(
              Icons.filter_alt_outlined,
              size: 22.w,
            ),
          ),
        ],
      ),
    );
  }

  @override
  StoreController getController() {
    return StoreController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "WareHouse";
  }
}
