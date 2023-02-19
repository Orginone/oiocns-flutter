import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/components/widgets/text_tag.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class SpaceItemWidget extends GetView<SettingController> {
  final Function(ISpace)? onTap;
  final ISpace space;
  final bool isCurrent;

  const SpaceItemWidget({
    Key? key,
    required this.space,
    required this.isCurrent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) {
          onTap!(space);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w),
        child: _body,
      ),
    );
  }

  Widget get _body {
    var spaceName = controller.spaceName(space);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAvatar(avatarName: spaceName.substring(0, 1)),
        Container(margin: EdgeInsets.only(left: 10.w)),
        Expanded(
          child: Text(
            spaceName,
            style: XFonts.size18Black0,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Visibility(
          visible: isCurrent,
          child: TextTag(
            "当前空间",
            bgColor: Colors.green,
            textStyle: XFonts.size12White,
            padding: const EdgeInsets.all(4),
          ),
        )
      ],
    );
  }
}
