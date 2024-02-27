import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main_base.dart';

class MessageChatInfoState extends BaseGetState {
  late ISession chat;

  late bool isFriend;

  MessageChatInfoState() {
    chat = Get.arguments['chat'];
    if (chat.share.typeName == TargetType.person.label) {
      var id = chat.chatdata.value.fullId.split('-').last;
      isFriend = null != relationCtrl.user
          ? relationCtrl.user!.members
                  .firstWhereOrNull((element) => element.id == id) !=
              null
          : false;
    } else {
      isFriend = true;
    }
  }
}
