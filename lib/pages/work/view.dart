import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/widget/unified.dart';
import 'logic.dart';
import 'state.dart';
import 'item.dart';

class WorkPage extends BaseGetListPageView<WorkController, WorkState> {
  @override
  Widget buildView() {
    return Container(
      color: GYColors.backgroundColor,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Obx(() {
          return ListView.builder(
            itemBuilder: (context, index) {
              if(index == 0){
                return   recentlyOpened();
              }
              return Item(
                todo: state.dataList[index-1],
              );
            },
            itemCount: state.dataList.length+1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        }),
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
                  "最近办事",
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

                if (index !=
                    (state.recentlyList.length - 1)) {
                  child = Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: child,
                  );
                }
                return Container(
                  margin:EdgeInsets.only(left: index == 0 ? 0 : 27),
                  child: child,
                );;
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

  @override
  WorkController getController() {
    return WorkController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "work";
  }
}
