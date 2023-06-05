import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/unified.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';
class StorePage
    extends BaseGetPageView<StoreController, StoreState> {
  @override
  Widget buildView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              itemBuilder: (BuildContext context, int index) {
                var item = state.recentlyList[index];
                return button(item);
              },
              itemCount: state.recentlyList.length,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return content();
                }
                return StoreItem();
              },
              itemCount: 11,
            ),
          )
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "共10项内容",
            style: XFonts.size18Black9,
          ),
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: 'time',
                child: Text('存储时间'),
              )
            ],
            onChanged: (String? value) {},
            value: "time",
            underline: const SizedBox(),
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
