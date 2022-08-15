import 'package:flutter/widgets.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:orginone/component/message_type/text_message.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../../config/constant.dart';
import '../../../../../enumeration/enum_map.dart';
import '../../../../../enumeration/message_type.dart';
import '../../../../../model/model.dart';
import '../../../../../model/user_info.dart';

enum Direction { leftStart, rightStart }

class ChatMessageItem extends StatelessWidget {
  final MessageDetail messageDetail;

  const ChatMessageItem(this.messageDetail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInfo userInfo = HiveUtil().getValue(Keys.userInfo);
    bool isMy = messageDetail.fromId.toString() == userInfo.id;

    return Row(
      textDirection: isMy ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: const GFAvatar(
              size: GFSize.SMALL,
              backgroundImage: NetworkImage(Constant.testUrl),
              shape: GFAvatarShape.standard),
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: _getMessage())
      ],
    );
  }

  Widget _getMessage() {
    MessageType messageType =
        EnumMap.messageTypeMap[messageDetail.msgType] ?? MessageType.unknown;

    switch (messageType) {
      case MessageType.text:
      case MessageType.unknown:
        return TextMessage(messageDetail.msgBody);
    }
  }
}
