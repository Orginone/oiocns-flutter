import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/setting/index.dart';
import 'package:orginone/routers.dart';

class UserBar extends GetView<SettingController> {
  const UserBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.signed ? _container : _empty);
  }

  Widget get _empty => Container();

  Widget get _container {
    return Row(children: [
      Expanded(
        child: Obx(() {
          var target = controller.space.target;
          var spaceName = target.name;
          return GestureDetector(
            onTap: () => Get.toNamed(Routers.spaces),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _avatar,
                Container(margin: EdgeInsets.only(left: 10.w)),
                Text(
                  spaceName,
                  style: XFonts.size22White,
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
      _avatar,
    ]);
  }

  Widget get _avatar {
    return TextAvatar(
      radius: 45.w,
      width: 45.w,
      avatarName: controller.user!.name.substring(0, 1),
      textStyle: XFonts.size22White,
      margin: EdgeInsets.only(right: 20.w),
    );
  }
}
