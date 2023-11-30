import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'package:orginone/components/widgets/keep_alive_widget.dart';

import 'message_chats_controller.dart';
import 'message_chats_state.dart';
import 'message_sub_page/view.dart';

class MessageChats
    extends BaseSubmenuPage<MessageChatsController, MessageChatsState> {
  const MessageChats({super.key});

  @override
  Widget buildPageView(String type, String label) {
    return KeepAliveWidget(child: MessageSubPage(type, label));
  }
}
