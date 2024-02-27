import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/utils/load_image.dart';

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
      XImage.entityIcon(target, width: 40)
          .clipRRect(all: 8.w)
          .marginOnly(right: AppSpace.listItem),
      // TeamAvatar(
      //   info: TeamTypeInfo(userId: target.id),
      //   size: 50.w,
      // ).clipRRect(all: 8.w).marginOnly(right: AppSpace.listItem),
      <Widget>[
        Text(target.name!),
        Text(
          hint,
          maxLines: 1,
          style: AppTextStyles.labelMedium?.copyWith(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        )
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingVertical(AppSpace.listItem)
          .border(bottom: 0.5, color: Colors.grey.shade300)
          .expanded()
    ].toRow().paddingLeft(AppSpace.page);
  }
}
