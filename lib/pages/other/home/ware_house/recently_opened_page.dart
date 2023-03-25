import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import './oiocns_components/apply_button.dart';
import './recently_opened_controller.dart';

class RecentlyOpenedPage extends StatelessWidget {
  const RecentlyOpenedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecentlyOpenedController controller = Get.put(RecentlyOpenedController());
    return Stack(children: [
      Container(
          width: double.infinity,
          height: 130.h,
          // margin: EdgeInsets.only(left: 28.w),
          decoration: const BoxDecoration(
              // border: Border(
              //     bottom: BorderSide(
              //         width: 1, color: Color.fromARGB(255, 211, 211, 211))),
              ),
          child: Obx(() {
            return PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (controller.recentlyList.length / 5).ceil(),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  ],
                );
              },
              onPageChanged: (index) {
                controller.currentIndex.value = index;
              },
            );
          })),
      Positioned(
          left: 0,
          right: 0,
          bottom: 20.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate((controller.recentlyList.length / 5).ceil(),
                (index) {
              return Obx(() {
                return Container(
                  width: controller.currentIndex == index.obs ? 14.w : 7.w,
                  height: 7.h,
                  margin: EdgeInsets.symmetric(horizontal: 3.5.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: controller.currentIndex == index.obs
                          ? const Color.fromARGB(255, 38, 60, 204)
                          : const Color.fromARGB(255, 223, 226, 241)),
                );
              });
            }),
          ))
    ]);
  }
}
