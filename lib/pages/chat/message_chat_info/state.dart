import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';

class MessageChatInfoState extends BaseGetState {
  late ISession chat;

  late bool isFriend;

  MessageChatInfoState() {
    chat = Get.arguments['chat'];
    if (chat.share.typeName == TargetType.person.label) {
      var id = chat.chatdata.value.fullId.split('-').last;
      isFriend = relationCtrl.user.members
              .firstWhereOrNull((element) => element.id == id) !=
          null;
    } else {
      isFriend = true;
    }
  }
}
