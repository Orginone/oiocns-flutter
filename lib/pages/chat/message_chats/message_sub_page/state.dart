import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_routers.dart';

class MessageSubState extends BaseGetState {
  ChatBreadcrumbNav? nav;

  RxList<IMsgChat> get chats => [
        ...settingCtrl.provider.chat?.topChats ?? <IMsgChat>[],
        ...settingCtrl.provider.chat?.chats ?? <IMsgChat>[],
      ].obs;
}
