import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_state.dart';

class MessageChatsState extends BaseFrequentlyUsedListState<MessageFrequentlyUsed,dynamic> {

  MessageChatsState() {}
}


class MessageFrequentlyUsed extends FrequentlyUsed{
  late IMsgChat chat;

  MessageFrequentlyUsed({super.id, super.name, super.avatar,required this.chat});

}