import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';

class MessageReceiveItem extends StatelessWidget {
  const MessageReceiveItem({
    super.key,
    required this.target,
    required this.hint,
  });

  final XTarget target;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  Widget _buildView() {
    return <Widget>[
      TeamAvatar(
        info: TeamTypeInfo(userId: target.id),
        size: 50.w,
      ).clipRRect(all: 8.w).marginOnly(right: GYSpace.listItem),
      <Widget>[
        Text(target.name!),
        Text(
          hint,
          maxLines: 1,
          style: GYTextStyles.labelMedium?.copyWith(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        )
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingVertical(GYSpace.listItem)
          .border(bottom: 0.5, color: Colors.grey.shade300)
          .expanded()
    ].toRow().paddingLeft(GYSpace.page);
  }
}
