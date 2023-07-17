import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_state.dart';
import 'package:orginone/routers.dart';

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
  void initSubmenu() {
    // TODO: implement initSubmenu
    super.initSubmenu();
    state.submenu.value = [
      SubmenuType(text: "全部", value: 'all'),
      SubmenuType(text: "常用", value: 'common'),
      SubmenuType(text: "最近", value: 'recent'),
      SubmenuType(text: "未读", value: 'unread'),
      SubmenuType(text: "单聊", value: 'single'),
      SubmenuType(text: "群聊", value: 'group'),
    ];
  }
  
  @override
  void onReady() {
    loadSuccess();
  }
  
  

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    // TODO: implement loadData
    await settingCtrl.provider.reloadChats();
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
  }

  @override
  void onTapFrequentlyUsed(used) {
    if(used is MessageFrequentlyUsed){
      used.chat.onMessage();
      Get.toNamed(
        Routers.messageChat,
        arguments: used.chat,
      );
    }
  }
}
