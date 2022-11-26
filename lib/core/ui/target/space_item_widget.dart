import 'package:flutter/material.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_edge_insets.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/util/string_util.dart';

class SpaceItemWidget extends StatelessWidget {
  final Function? onTap;
  final Company company;
  final bool isCurrent;

  const SpaceItemWidget({
    Key? key,
    required this.company,
    required this.isCurrent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) {
          onTap!(company);
        }
      },
      child: Container(
        padding: lr20t10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextAvatar(
              avatarName: StringUtil.getAvatarName(
                avatarName: company.target.name,
                type: TextAvatarType.space,
              ),
            ),
            Container(margin: left10),
            Expanded(
              child: Text(
                company.target.name,
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
        ),
      ),
    );
  }
}
