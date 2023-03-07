import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import './market_controller.dart';

class MarketApplyList extends StatelessWidget {
  const MarketApplyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MarketController controller = Get.put(MarketController());
    return Container(
        height: 900.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.applyList.length,
            itemBuilder: (BuildContext context, int index) {
              return MarketApplyCard(applyIteam: controller.applyList[index]);
            },
          );
        }));
  }
}

class MarketApplyCard extends StatelessWidget {
  final ApplyIteam applyIteam;
  const MarketApplyCard({Key? key, required this.applyIteam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(6.w))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.0.w,
            height: 80.0.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(applyIteam.imageUrl))),
                ),
                Text(
                  applyIteam.versionNumber,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w100,
                      color: const Color.fromARGB(255, 188, 189, 194)),
                )
              ],
            ),
          ),
          messagePart(),
          buttonRow(),
        ],
      ),
    );
  }

  Widget messagePart() {
    return SizedBox(
      width: 220.w,
      height: 80.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            applyIteam.name,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            applyIteam.message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w100,
                color: const Color.fromARGB(255, 77, 79, 83)),
          ),
        ],
      ),
    );
  }

  Widget buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 2.h),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1.w, color: const Color.fromARGB(255, 27, 47, 203)),
                borderRadius: BorderRadius.all(Radius.circular(12.w))),
            child: Text(
              "加入购物车",
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 27, 47, 203)),
            ),
          ),
          onTap: () {
            // get.to
          },
        ),
        SizedBox(
          width: 10.w,
        ),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 2.h),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1.w, color: const Color.fromARGB(255, 27, 47, 203)),
                borderRadius: BorderRadius.all(Radius.circular(12.w))),
            child: Text(
              "获取",
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 27, 47, 203)),
            ),
          ),
          onTap: () {
            // get.to
          },
        )
      ],
    );
  }
}
