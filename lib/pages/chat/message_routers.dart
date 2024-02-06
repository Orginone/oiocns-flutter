import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/main_base.dart';

import 'widgets/message_breadcrumb_nav_item.dart';

class MessageRouters
    extends BaseBreadcrumbNavMultiplexPage<Controller, ChatBreadNavState> {
  MessageRouters({super.key});

  @override
  Widget body() {
    return SingleChildScrollView(child: Obx(() {
      var chats = state.model.value?.children
          .where((element) => element.name.contains(state.keyword))
          .toList();

      return Column(children: initiate(chats ?? []));
    }));
  }

  List<Widget> initiate(List<ChatBreadcrumbNav> chats) {
    List<Widget> children = [];
    for (var child in chats) {
      children.add(MessageBreadcrumbNavItem(
        item: child,
        onNext: () {
          controller.jumpNext(child);
        },
        onTap: () {
          controller.jumpDetails(child);
        },
        onSelected: (key) {
          controller.operation(key, child.target);
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
    for (var company in relationCtrl.user.companys) {
      companyItems.add(
        createNav(
            company.id,
            relationCtrl.chats.last,
            [
              createNav(
                "${company.id}0",
                relationCtrl.chats.last,
                company.memberChats
                    .map((item) => createNav(item.sessionId, item, []))
                    .toList(),
              ),
              ...company.cohortChats
                  .where((i) => i.isMyChat)
                  .map((item) => createNav(item.sessionId, item, [],
                      spaceEnum: SpaceEnum.departments))
                  .toList(),
            ],
            type: ChatType.list,
            spaceEnum: SpaceEnum.company),
      );
    }
    state.model.value = ChatBreadcrumbNav(children: [
      createNav(
          relationCtrl.user.id,
          relationCtrl.chats.last,
          [
            createNav(
              "${relationCtrl.user.id}0",
              relationCtrl.chats.last,
              relationCtrl.user.memberChats
                  .map((chat) => createNav(chat.sessionId, chat, [],
                      spaceEnum: SpaceEnum.person))
                  .toList(),
            ),
            ...relationCtrl.user.cohortChats
                .where((i) => i.isMyChat)
                .map((item) => createNav(item.sessionId, item, [],
                    spaceEnum: SpaceEnum.departments))
                .toList(),
          ],
          type: ChatType.list),
      ...companyItems,
    ], name: "沟通", target: relationCtrl.chats.last);
    print('');
  }

  ChatBreadcrumbNav createNav(
      String id, ISession target, List<ChatBreadcrumbNav> children,
      {ChatType type = ChatType.chat, SpaceEnum? spaceEnum}) {
    dynamic image = target.share.avatar?.thumbnailUint8List ??
        target.share.avatar?.defaultAvatar;
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
    if (chat.type == ChatType.chat) {
      Get.toNamed(Routers.messageChatInfo, arguments: {"chat": chat.target});
    } else {
      Get.toNamed(Routers.messageChatsList, arguments: {
        "chats": (chat.target as ITeam)
            .memberChats
            .where((element) => element.isMyChat)
            .toList()
      });
    }
  }

  void operation(PopupMenuKey key, ISession msg) {
    if (key == PopupMenuKey.setCommon) {
      //TODO:无此方法
      // relationCtrl.chat.setMostUsed(msg);
    } else if (key == PopupMenuKey.removeCommon) {
      //TODO:无此方法
      // relationCtrl.chat.removeMostUsed(msg);
    }
  }
}

class ChatBreadNavState extends BaseBreadcrumbNavState<ChatBreadcrumbNav> {
  ChatBreadNavState() {
    if (Get.arguments is Map) {
      model.value = Get.arguments?['data'];
      title = model.value?.name ?? HomeEnum.chat.label;
    }
  }
}

class MessagesBinding extends BaseBindings<Controller> {
  @override
  Controller getController() {
    return Controller();
  }
}

class ChatBreadcrumbNav extends BaseBreadcrumbNavModel<ChatBreadcrumbNav> {
  ISession target;
  ChatType? type;
  void Function(ISession?, ChatBreadcrumbNav)? event;

  ChatBreadcrumbNav(
      {super.id = '',
      super.name = '',
      required List<ChatBreadcrumbNav> children,
      super.image,
      super.source,
      super.spaceEnum,
      required this.target,
      this.event,
      this.type}) {
    this.children = children;
  }
}

enum ChatType {
  chat,
  list,
}
