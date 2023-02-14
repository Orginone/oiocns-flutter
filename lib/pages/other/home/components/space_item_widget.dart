import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/text_avatar.dart';
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
        padding: ,
        child: _body,
      ),
    );
  }

  Widget get _body {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAvatar(avatarName: space.target.name.substring(0, 1)),
        Container(margin: left10),
        Expanded(
          child: Text(
            space.target.name,
            style: text18,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Visibility(
          visible: isCurrent,
          child: TextTag(
            "当前空间",
            bgColor: Colors.green,
            textStyle: text12White,
            padding: const EdgeInsets.all(4),
          ),
        )
      ],
    )
  }
}
