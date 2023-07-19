import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';

class MessageChatsState extends BaseSubmenuState<MessageFrequentlyUsed> {

@override
  // TODO: implement tag
  String get tag => "沟通";

}


class MessageFrequentlyUsed extends FrequentlyUsed{
  late IMsgChat chat;


  MessageFrequentlyUsed({super.id, super.name, super.avatar,required this.chat});

}