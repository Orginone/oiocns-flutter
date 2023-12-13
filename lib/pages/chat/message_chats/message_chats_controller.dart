import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_state.dart';
import 'package:orginone/utils/hive_utils.dart';

class MessageChatsController extends BaseSubmenuController<MessageChatsState> {
  @override
  final MessageChatsState state = MessageChatsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('>>>=======ChatInit1');
    print('>>>=======ChatInit2');
  }

  @override
  void initSubGroup() {
    // TODO: implement initSubGroup
    super.initSubGroup();
    print('>>>=======ChatInitSub1');
    var chat = HiveUtils.getSubGroup('chat');
    if (chat == null) {
      chat = SubGroup.fromJson(chatDefaultConfig);
      HiveUtils.putSubGroup('chat', chat);
    }
    state.subGroup = Rx(chat);
    state.tabController = TabController(
        initialIndex: state.tabIndex,
        length: chat.groups!.length,
        vsync: this,
        animationDuration: Duration.zero);
    print('>>>=======ChatInitSub2');
  }

  @override
  int getTabIndex(String code) {
    return SubGroup.fromJson(chatDefaultConfig)
        .groups!
        .indexWhere((element) => element.value == code);
  }
}
