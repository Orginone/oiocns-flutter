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
    return Obx(() => controller.signed ? _container : _empty);
  }

  Widget get _empty => Container();

  Widget get _container {
    return SizedBox(
      height: 74.h,
      child: Row(children: [
        Expanded(
          child: Obx(() {
            return GestureDetector(
              onTap: (){
                controller.jumpSpaces();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _avatar(EdgeInsets.only(left: 20.w)),
                  Container(margin: EdgeInsets.only(left: 10.w)),
                  Text(
                    controller.space.target.team?.name??"",
                    style: XFonts.size22Black0,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(margin: EdgeInsets.only(left: 2.w)),
                  const Icon(Icons.arrow_drop_down, color: XColors.black)
                ],
              ),
            );
          }),
        ),
        Padding(padding: EdgeInsets.only(left: 10.w)),
        _avatar(EdgeInsets.only(right: 20.w)),
      ]),
    );
  }

  Widget _avatar(EdgeInsets insets) {
    return TextAvatar(
      radius: 45.w,
      width: 45.w,
      avatarName: controller.user!.name.substring(0, 1),
      textStyle: XFonts.size22White,
      margin: insets,
    );
  }
}
