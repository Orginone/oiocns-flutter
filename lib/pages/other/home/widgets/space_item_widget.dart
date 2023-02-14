import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/components/widgets/text_tag.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class SpaceItemWidget extends StatelessWidget {
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
        padding: XInsets.l20r20t10,
        child: _body,
      ),
    );
  }

  Widget get _body {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAvatar(avatarName: space.target.name.substring(0, 1)),
        Container(margin: EdgeInsets.only(left: 10.w)),
        Expanded(
          child: Text(
            space.target.name,
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
