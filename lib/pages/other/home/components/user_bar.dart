import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/text_avatar.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/ts/controller/setting/index.dart';
import 'package:orginone/routers.dart';

class UserBar extends GetView<SettingController> {
  const UserBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.signedIn ? _container : _empty);
  }

  Widget get _empty => Container();

  Widget get _container {
    return Row(children: [
      Expanded(
        child: Obx(() {
          var target = controller.company.target;
          var spaceName = target.name;
          return GestureDetector(
            onTap: () => Get.toNamed(Routers.spaces),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextAvatar(
                  radius: 45.w,
                  width: 45.w,
                  avatarName: spaceKeyWord,
                  textStyle: text20White,
                  margin: EdgeInsets.only(left: 20.w),
                ),
                Container(margin: EdgeInsets.only(left: 10.w)),
                Text(
                  spaceName,
                  style: text22,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(margin: EdgeInsets.only(left: 2.w)),
                const Icon(Icons.arrow_drop_down, color: Colors.black)
              ],
            ),
          );
        }),
      ),
      Padding(padding: EdgeInsets.only(left: 10.w)),
      TextAvatar(
        radius: 45.w,
        width: 45.w,
        avatarName: userKeyWord,
        textStyle: XFonts.size22White,
        margin: EdgeInsets.only(right: 20.w),
      ),
    ]);
  }
}
