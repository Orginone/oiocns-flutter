


import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/main.dart';

class MessageChatInfoState extends BaseGetState{
  late IMsgChat chat;

  late bool isFriend;

  MessageChatInfoState(){
    chat = Get.arguments['chat'];
    if(chat.share.typeName == TargetType.person.label){
      var id = chat.chatdata.value.fullId.split('-').last;
      isFriend = settingCtrl.user.members.firstWhereOrNull((element) => element.id == id)!=null;
    }else{
      isFriend = true;
    }
  }
}