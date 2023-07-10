import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/chat_item.dart';
import 'message_chats_controller.dart';
import 'message_chats_state.dart';

class MessageChats extends BaseFrequentlyUsedListPage<MessageChatsController,
    MessageChatsState> {
  @override
  Widget buildView() {
    return Obx(() {
      return CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              var chat = settingCtrl.provider.chat!.topChats[index];
              return MessageItemWidget(chat: chat);
            }, childCount: settingCtrl.provider.chat?.topChats.length),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              var chat = settingCtrl.provider.chat!.chats[index];
              return MessageItemWidget(chat: chat);
            }, childCount: settingCtrl.provider.chat?.chats.length),
          ),
        ],
      );
    });
  }

  @override
  bool displayNoDataWidget() {
    // TODO: implement displayNoDataWidget
    return false;
  }
}
