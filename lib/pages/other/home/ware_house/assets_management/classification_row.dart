import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './assets_management_controller.dart';
import 'package:get/get.dart';

class ClassificationRow extends StatefulWidget {
  const ClassificationRow({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClassificationRowState createState() => _ClassificationRowState();
}

class _ClassificationRowState extends State<ClassificationRow> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    AssetsManagementController controller =
        Get.put(AssetsManagementController());
    return SizedBox(
      height: 40.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 28.h,
            margin: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "全部",
                    style: index == 0
                        ? TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 52, 52, 54),
                            fontWeight: FontWeight.w600)
                        : TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 107, 109, 113),
                            fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: 14.sp,
                    height: 2.sp,
                    decoration: BoxDecoration(
                        color: index == 0
                            ? const Color.fromARGB(255, 71, 90, 212)
                            : const Color.fromARGB(255, 242, 244, 248)),
                  )
                ],
              ),
              onTap: () {
                setState(
                    () => controller.classificationIndex.value = index = 0);
              }, //
            ),
          ),
          Container(
            height: 28.h,
            margin: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "创建的",
                    style: index == 1
                        ? TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 52, 52, 54),
                            fontWeight: FontWeight.w600)
                        : TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 107, 109, 113),
                            fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: 26.sp,
                    height: 2.sp,
                    decoration: BoxDecoration(
                        color: index == 1
                            ? const Color.fromARGB(255, 71, 90, 212)
                            : const Color.fromARGB(255, 242, 244, 248)),
                  )
                ],
              ),
              onTap: () {
                setState(
                    () => controller.classificationIndex.value = index = 1);
              }, //
            ),
          ),
          Container(
            height: 28.h,
            margin: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "购买的",
                    style: index == 2
                        ? TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 52, 52, 54),
                            fontWeight: FontWeight.w600)
                        : TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 107, 109, 113),
                            fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: 26.sp,
                    height: 2.sp,
                    decoration: BoxDecoration(
                        color: index == 2
                            ? const Color.fromARGB(255, 71, 90, 212)
                            : const Color.fromARGB(255, 242, 244, 248)),
                  )
                ],
              ),
              onTap: () {
                setState(
                    () => controller.classificationIndex.value = index = 2);
              }, //
            ),
          ),
          Container(
            height: 28.h,
            margin: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "共享的",
                    style: index == 3
                        ? TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 52, 52, 54),
                            fontWeight: FontWeight.w600)
                        : TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 107, 109, 113),
                            fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: 26.sp,
                    height: 2.sp,
                    decoration: BoxDecoration(
                        color: index == 3
                            ? const Color.fromARGB(255, 71, 90, 212)
                            : const Color.fromARGB(255, 242, 244, 248)),
                  )
                ],
              ),
              onTap: () {
                setState(
                    () => controller.classificationIndex.value = index = 3);
              }, //
            ),
          ),
          Container(
            height: 28.h,
            margin: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "分配的",
                    style: index == 4
                        ? TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 52, 52, 54),
                            fontWeight: FontWeight.w600)
                        : TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromARGB(255, 107, 109, 113),
                            fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: 26.sp,
                    height: 2.sp,
                    decoration: BoxDecoration(
                        color: index == 4
                            ? const Color.fromARGB(255, 71, 90, 212)
                            : const Color.fromARGB(255, 242, 244, 248)),
                  )
                ],
              ),
              onTap: () {
                setState(
                    () => controller.classificationIndex.value = index = 4);
              }, //
            ),
          )
        ],
      ),
    );
  }
}
