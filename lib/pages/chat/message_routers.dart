import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/common_widget.dart';

class MessageRouters
    extends BaseBreadcrumbNavMultiplexPage<Controller, ChatBreadNavState> {
  @override
  Widget body() {
    return SingleChildScrollView(child: Column(children: initiate()));
  }

  List<Widget> initiate() {
    List<Widget> children = [];
    for (var child in state.model.value!.children) {
      children.add(Column(
        children: [
          CommonWidget.commonHeadInfoWidget(child.name),
          ...child.children.map((e) {
            return BaseBreadcrumbNavItem<ChatBreadcrumbNav>(
              item: e,
              onNext: () {
                e.event?.call(e.target, e);
              },
            );
          }).toList(),
        ],
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
}

class ChatBreadNavState extends BaseBreadcrumbNavState<ChatBreadcrumbNav> {
  SettingController get settingCtrl => Get.find<SettingController>();

  ChatBreadNavState() {
    var joinedCompanies = settingCtrl.provider.user?.companys;
    model.value = Get.arguments?['data'];
    if (model.value == null && joinedCompanies != null) {
      List<ChatBreadcrumbNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          ChatBreadcrumbNav(
            name: value.metadata.name,
            id: value.metadata.id,
            target: value,
            children: [],
            image: value.metadata.avatarThumbnail(),
            event: (target, nav) {
              jumpNext(nav);
            },
          ),
        );
      }
      var chats = settingCtrl.provider.user?.user.chats ?? [];
      model.value = ChatBreadcrumbNav(
        name: "沟通",
        children: [
          ChatBreadcrumbNav(
            name: "个人",
            children: chats
                .map((item) => ChatBreadcrumbNav(
                    target: item,
                    name: item.chatdata.value.chatName ?? "",
                    children: [],
                    event: (chat, nav) {
                      chat?.onMessage();
                      Get.toNamed(Routers.messageChat, arguments: chat);
                    }))
                .toList(),
          ),
          ChatBreadcrumbNav(
            name: "组织",
            children: organization,
          )
        ],
      );
    }
    var company = model.value?.target;
    if (company != null && company is ICompany) {
      model.value!.children = [
        ChatBreadcrumbNav(
            name: company.chatdata.value.chatName ?? "",
            event: (chat, nav) {
              chat?.onMessage();
              Get.toNamed(Routers.messageChat, arguments: chat);
            },
            children: company.memberChats
                .map((item) => ChatBreadcrumbNav(
                    target: item,
                    name: item.chatdata.value.chatName ?? "",
                    children: [],
                    event: (chat, nav) {
                      chat?.onMessage();
                      Get.toNamed(Routers.messageChat, arguments: chat);
                    }))
                .toList()),
        ChatBreadcrumbNav(
          name: "群组",
          event: (chat, nav) {
            chat?.onMessage();
            Get.toNamed(Routers.messageChat, arguments: chat);
          },
          children: company.cohortChats
              .map((item) => ChatBreadcrumbNav(
                  target: item,
                  name: item.chatdata.value.chatName ?? "",
                  children: [],
                  event: (chat, nav) {
                    chat?.onMessage();
                    Get.toNamed(Routers.messageChat, arguments: chat);
                  }))
              .toList(),
        )
      ];
    }
    title = model.value?.name ?? "";
  }

  void jumpNext(ChatBreadcrumbNav work) {
    Get.toNamed(Routers.initiateChat,
        preventDuplicates: false, arguments: {"data": work});
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
  void Function(IMsgChat?, ChatBreadcrumbNav)? event;

  ChatBreadcrumbNav({
    super.id = '',
    super.name = '',
    required List<ChatBreadcrumbNav> children,
    super.image,
    super.source,
    this.target,
    this.event,
  }) {
    this.children = children;
  }
}
