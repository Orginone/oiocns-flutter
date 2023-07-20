


import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class MessageChatInfoState extends BaseGetState{
  late IMsgChat chat;

  MessageChatInfoState(){
    chat = Get.arguments['chat'];
  }
}