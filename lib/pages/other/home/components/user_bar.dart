import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/routers.dart';

class UserBar extends GetView<SettingController> {
  const UserBar({super.key});

  @override
  Widget build(BuildContext context) {
    return _container;
  }

  Widget get _empty => Container();

  Widget get _container {
    return SizedBox(
      height: 74.h,
      child: Row(children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.jumpSpaces();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _avatar(EdgeInsets.only(left: 20.w)),
                Container(margin: EdgeInsets.only(left: 10.w)),
                Obx(() {
                  return Text(
                    controller.signed
                        ? controller.space.teamName
                        : "",
                    style: XFonts.size22Black0,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
                Container(margin: EdgeInsets.only(left: 2.w)),
                const Icon(Icons.arrow_drop_down, color: XColors.black)
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: GestureDetector(
            child: _avatar(EdgeInsets.only(right: 10.w)),
            onTap: () {
              Get.toNamed(Routers.personPage);
            },
          ),
        ),
      ]),
    );
  }

  Widget _avatar(EdgeInsets insets) {
    return Obx(() {
      var avatar = controller.signed?controller.space.shareInfo.avatar?.thumbnail?.split(",")[1].replaceAll('\r', '').replaceAll('\n', ''):"";
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image:  MemoryImage(base64Decode(avatar??""),),fit: BoxFit.fill)
        ),
        width: 45.w,
        margin: insets,
      );
    });
  }
}
