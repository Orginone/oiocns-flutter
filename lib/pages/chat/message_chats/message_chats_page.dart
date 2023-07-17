import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'message_chats_controller.dart';
import 'message_chats_state.dart';
import 'message_sub_page/view.dart';

class MessageChats extends BaseSubmenuPage<MessageChatsController,
    MessageChatsState> {

  @override
  bool displayNoDataWidget() {
    // TODO: implement displayNoDataWidget
    return false;
  }

  @override
  Widget buildPageView(BuildContext context, int index) {
    return KeepAliveWidget(child: MessageSubPage(state.submenu[index].value));
  }
}
