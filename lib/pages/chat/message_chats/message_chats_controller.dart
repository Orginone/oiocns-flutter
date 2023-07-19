import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/model/subgroup_config.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hive_utils.dart';

class MessageChatsController
    extends BaseSubmenuController<MessageChatsState> {
  @override
  final MessageChatsState state = MessageChatsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  @override
  void initSubGroup() {
    // TODO: implement initSubGroup
    super.initSubGroup();
    var chat = HiveUtils.getSubGroup('chat');
    if(chat==null){
      chat = SubGroup.fromJson(chatDefaultConfig);
      HiveUtils.putSubGroup('chat', chat);
    }
    state.subGroup = Rx(chat);
  }


}
