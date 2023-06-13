


import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_state.dart';

class MessageChatsState extends BaseFrequentlyUsedListState<MessageRecent,dynamic> {

  MessageChatsState() {}
}


class MessageRecent extends Recent{
  late IMsgChat chat;

  MessageRecent({super.id, super.name, super.avatar,required this.chat});

}