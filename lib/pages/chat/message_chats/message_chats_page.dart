import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/chat_item.dart';
import 'message_chats_controller.dart';
import 'message_chats_state.dart';

class MessageChats extends BaseFrequentlyUsedListPage<MessageChatsController,
    MessageChatsState> {
  @override
  Widget buildView() {
    var topChats = settingCtrl.provider.chat?.topChats??[];

    var chats = settingCtrl.provider.chat?.chats??[];

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            var chat = topChats[index];
            return MessageItemWidget(chat: chat);
          }, childCount: topChats.length),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            var chat = chats[index];
            return MessageItemWidget(chat: chat);
          }, childCount: chats.length),
        ),
      ],
    );
  }

  @override
  MessageChatsController getController() {
    return MessageChatsController();
  }

  @override
  bool displayNoDataWidget() {
    // TODO: implement displayNoDataWidget
    return false;
  }

  @override
  String tag() {
    // TODO: implement tag
    return "MessageChats";
  }
}




