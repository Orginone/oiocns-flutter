import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/chat/message_routers.dart';

class MessageSubState extends BaseGetListState {
  ChatBreadcrumbNav? nav;

  ScrollController scrollController = ScrollController();

  RxList<ISession> get chats => relationCtrl.chats;
  // RxList<IMsgChat> get chats => [
  //       ...relationCtrl.provider.chat?.topChats ?? <IMsgChat>[],
  //       ...relationCtrl.provider.chat?.chats ?? <IMsgChat>[],
  //     ].obs;
}
