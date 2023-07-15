import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/list_adapter.dart';
import 'package:orginone/main.dart';

import 'message_chats_controller.dart';
import 'message_chats_state.dart';

class MessageChats extends BaseFrequentlyUsedListPage<MessageChatsController,
    MessageChatsState> {
  @override
  Widget buildView() {
    return Obx(() {
      var chats = [
        ...settingCtrl.provider.chat?.topChats ?? [],
        ...settingCtrl.provider.chat?.chats ?? [],
      ];

      state.adapter.value = chats.map((e) => ListAdapter.chat(e)).toList();
      return super.buildView();
    });
  }

  @override
  Widget headWidget() {
     return Obx((){
       state.mostUsedList.value = settingCtrl.chat.messageFrequentlyUsed;
       state.mostUsedList.refresh();
       return super.headWidget();
     });
  }

  @override
  bool displayNoDataWidget() {
    // TODO: implement displayNoDataWidget
    return false;
  }
}
