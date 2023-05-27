import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/routers.dart';

class MessageRouters
    extends BaseBreadcrumbNavMultiplexPage<Controller, ChatBreadNavState> {
  @override
  Widget body() {
    return SingleChildScrollView(child: Obx(() {
      return Column(children: initiate());
    }));
  }

  List<Widget> initiate() {
    List<Widget> children = [];
    for (var child in state.model.value?.children ?? []) {
      children.add(BaseBreadcrumbNavItem<ChatBreadcrumbNav>(
        item: child,
        onNext: () {
          controller.jumpNext(child);
        },
        onTap: () {
          controller.jumpDetails(child);
        },
      ));
    }
    return children;
  }

  @override
  Controller getController() {
    return Controller();
  }
}

class Controller extends BaseBreadcrumbNavController<ChatBreadNavState> {
  final settingCtrl = Get.find<SettingController>();

  @override
  final ChatBreadNavState state = ChatBreadNavState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    if (state.model.value == null) {
      initChatBreadNav();
    }
  }

  initChatBreadNav() async {
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
                  .map((item) => createNav(item.chatId, item, []))
                  .toList(),
            ],
            type: ChatType.list),
      );
    }
    state.model.value = ChatBreadcrumbNav(children: [
      createNav(
          settingCtrl.user.id,
          settingCtrl.user,
          [
            createNav(
              "${settingCtrl.user.id}0",
              settingCtrl.user,
              settingCtrl.user.memberChats
                  .map((chat) => createNav(chat.chatId, chat, []))
                  .toList(),
            ),
            ...settingCtrl.user.cohortChats
                .where((i) => i.isMyChat)
                .map((item) => createNav(item.chatId, item, []))
                .toList(),
          ],
          type: ChatType.list),
      ...companyItems,
    ], name: "沟通");
    print('');
  }

  ChatBreadcrumbNav createNav(
      String id, IMsgChat target, List<ChatBreadcrumbNav> children,
      {ChatType type = ChatType.chat}) {

    var image;
    if(target.share.avatar?.thumbnail?.contains("default")??false){
      image = target.share.avatar?.thumbnail;
    }else{
      image = target.share.avatar?.thumbnailUint8List;
    }
    return ChatBreadcrumbNav(
        id: id,
        type: type,
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

class ChatBreadNavState extends BaseBreadcrumbNavState<ChatBreadcrumbNav> {
  SettingController get settingCtrl => Get.find<SettingController>();

  ChatBreadNavState() {
    model.value = Get.arguments?['data'];
    title = model.value?.name ?? HomeEnum.chat.label;
  }
}

class MessagesBinding extends BaseBindings<Controller> {
  @override
  Controller getController() {
    return Controller();
  }
}

class ChatBreadcrumbNav extends BaseBreadcrumbNavModel<ChatBreadcrumbNav> {
  IMsgChat? target;
  ChatType? type;
  void Function(IMsgChat?, ChatBreadcrumbNav)? event;

  ChatBreadcrumbNav(
      {super.id = '',
      super.name = '',
      required List<ChatBreadcrumbNav> children,
      super.image,
      super.source,
      this.target,
      this.event,
      this.type}) {
    this.children = children;
  }
}

enum ChatType {
  chat,
  list,
}
