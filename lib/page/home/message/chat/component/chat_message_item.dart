import 'package:flutter/widgets.dart';
import 'package:orginone/page/home/message/chat/component/text_message.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../../config/custom_colors.dart';
import '../../../../../enumeration/enum_map.dart';
import '../../../../../enumeration/message_type.dart';
import '../../../../../model/model.dart';
import '../../../../../model/user_info.dart';

enum Direction { leftStart, rightStart }

class ChatMessageItem extends StatelessWidget {
  final MessageDetail messageDetail;
  final MessageGroup messageGroup;

  const ChatMessageItem(this.messageGroup, this.messageDetail, {Key? key})
      : super(key: key);

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
          child: Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: CustomColors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(messageGroup.name!
                  .substring(0, messageGroup.name!.length >= 2 ? 2 : 1)
                  .toUpperCase())),
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
