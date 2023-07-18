import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/message_breadcrumb_nav_item.dart';

import 'logic.dart';
import 'state.dart';

class MessageSubPage
    extends BaseGetPageView<MessageSubController, MessageSubState> {
  late String type;

  MessageSubPage(this.type);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }

  @override
  Widget buildView() {
    if (type == 'all') {
      return allWidget();
    }
    if (type == 'common') {
      return commonWidget();
    }
    return messageWidget();
  }

  Widget allWidget() {
    return SingleChildScrollView(
        child: Column(
            children: state.nav!.children
                .map((e) =>
                MessageBreadcrumbNavItem(
                  item: e,
                  onNext: () {
                    controller.jumpNext(e);
                  },
                  onTap: () {
                    controller.jumpDetails(e);
                  },
                  onSelected: (key) {},
                ))
                .toList()));
  }

  Widget commonWidget() {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = settingCtrl.chat.messageFrequentlyUsed[index];
          return ListItem(adapter: ListAdapter.chat(item.chat));
        },
        itemCount: settingCtrl.chat.messageFrequentlyUsed.length,
      );
    });
  }

  Widget messageWidget() {
    return Obx(() {
      List<IMsgChat> chats = state.chats;
      if(type == "unread"){
        chats = chats.where((element) => element.chatdata.value.noReadCount !=0).toList();
      }
      if(type == "single"){
        chats = chats.where((element) => element.share.typeName == TargetType.person.label).toList();
      }
      if(type == "group"){
        chats = chats.where((element) => element.share.typeName != TargetType.person.label).toList();
      }
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = chats[index];
          return ListItem(adapter: ListAdapter.chat(item));
        },
        itemCount: chats.length,
      );
    });
  }

  @override
  MessageSubController getController() {
    return MessageSubController(type);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "message_$type";
  }
}
