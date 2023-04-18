import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/routers.dart';

import '../ware_house/state.dart';
import 'logic.dart';
import 'state.dart';

class ShopPage extends BaseGetPageView<ShopController,ShopState>{
  @override
  Widget buildView() {
    return Container(
      color: GYColors.backgroundColor,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,mainAxisSpacing: 4.w,crossAxisSpacing: 10.h,mainAxisExtent: 80.w),
            itemBuilder: (BuildContext context, int index) {
              var item = state.recentlyList[index];
              return  button(item);
            },
            itemCount: state.recentlyList.length,
          ),
        ),
      ),
    );
  }


  Widget button(Recent recent) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routers.file);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50.w,
            height: 50.w,
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
  ShopController getController() {
    return ShopController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "shop";
  }
}