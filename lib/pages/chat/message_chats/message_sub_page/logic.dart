import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_routers.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class MessageSubController extends BaseController<MessageSubState> {
 final MessageSubState state = MessageSubState();

 late String type;

 MessageSubController(this.type);

 @override
 void onInit() async{
  super.onInit();
  await initChatBreadNav();
 }

 Future<void> initChatBreadNav() async {
  List<ChatBreadcrumbNav> companyItems = [];
  for (var company in settingCtrl.user.companys) {
   companyItems.add(
    createNav(
        company.id,
        company,
        [
         createNav(
          "${company.id}0",
          company,
          company.memberChats
              .map((item) => createNav(item.chatId, item, []))
              .toList(),
         ),
         ...company.cohortChats
             .where((i) => i.isMyChat)
             .map((item) => createNav(item.chatId, item, [],spaceEnum: SpaceEnum.departments))
             .toList(),
        ],
        type: ChatType.list,spaceEnum: SpaceEnum.company),
   );
  }
  state.nav = ChatBreadcrumbNav(children: [
   createNav(
       settingCtrl.user.id,
       settingCtrl.user,
       [
        createNav(
         "${settingCtrl.user.id}0",
         settingCtrl.user,
         settingCtrl.user.memberChats
             .map((chat) => createNav(chat.chatId, chat, [],spaceEnum: SpaceEnum.person))
             .toList(),
        ),
        ...settingCtrl.user.cohortChats
            .where((i) => i.isMyChat)
            .map((item) => createNav(item.chatId, item, [],spaceEnum: SpaceEnum.departments))
            .toList(),
       ],
       type: ChatType.list),
   ...companyItems,
  ], name: "沟通");
 }

 ChatBreadcrumbNav createNav(
     String id, IMsgChat target, List<ChatBreadcrumbNav> children,
     {ChatType type = ChatType.chat,SpaceEnum? spaceEnum}) {

  dynamic image = target.share.avatar?.thumbnailUint8List??target.share.avatar?.defaultAvatar;
  return ChatBreadcrumbNav(
      id: id,
      type: type,
      spaceEnum: spaceEnum,
      children: children,
      name: target.chatdata.value.chatName ?? "",
      target: target,
      image: image);
 }

 void jumpNext(ChatBreadcrumbNav chat) {
  if (chat.children.isEmpty) {
   jumpDetails(chat);
  } else {
   Get.toNamed(Routers.initiateChat,
       preventDuplicates: false, arguments: {"data": chat});
  }
 }

 void jumpDetails(ChatBreadcrumbNav chat) {
  if(chat.type == ChatType.chat){
   chat.target?.onMessage();
   Get.toNamed(Routers.messageChat, arguments: chat.target);
  }else{
   Get.toNamed(Routers.messageChatsList, arguments: {"chats":(chat.target as ITeam).chats.where((element) => element.isMyChat).toList()});
  }
 }




}
