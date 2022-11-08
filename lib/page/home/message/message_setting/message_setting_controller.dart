import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/cohort_api.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import '../../../../api/person_api.dart';
import '../../../../api_resp/message_item_resp.dart';
import '../../../../logic/authority.dart';
import '../../../../util/hub_util.dart';

class MessageSettingController extends GetxController {
  final Logger log = Logger("MessageSettingController");

  TextEditingController searchGroupTextController = TextEditingController();

  MessageController messageController = Get.find<MessageController>();
  ChatController chatController = Get.find<ChatController>();

  // 当前观察对象
  late MessageItemResp messageItem;
  late String spaceId;
  late String messageItemId;

  // 人员列表
  late bool hasReminder;
  late List<TargetResp> persons;
  late bool isRelationAdmin;
  late int offset;
  late int limit;

  @override
  void onInit() async {
    super.onInit();

    //初始化
    Map<String, dynamic> args = Get.arguments;
    spaceId = args["spaceId"];
    messageItemId = args["messageItemId"];
    messageItem = args["messageItem"];
    isRelationAdmin = auth.isRelationAdmin([messageItemId]);

    hasReminder = true;
    offset = 0;
    limit = 15;
    persons = [];
    await getPersons(isRelationAdmin ? 14 : 15);
  }

  /// 查询群成员信息
  Future<void> getPersons(int limit) async {
    PageResp<TargetResp> ans = await HubUtil().getPersons(
      messageItemId,
      limit,
      offset,
    );
    persons.addAll(ans.result);
    offset += ans.result.length;

    hasReminder = ans.total > persons.length;
    update();
  }

  morePersons() {
    getPersons(limit);
  }

  /// 消息免打扰
  interruptionOrNot(bool trueOrNot) async {
    var orgChatCache = messageController.orgChatCache;

    // 会话中止
    orgChatCache.chats.where((space) => space.id == spaceId).forEach((space) {
      space.chats.where((chat) => chat.id == messageItemId).forEach((item) {
        item.isInterruption = trueOrNot;
      });
    });

    // 近期会话
    orgChatCache.recentChats?.forEach((chat) {
      chat.isInterruption = trueOrNot;
    });

    // 打开的会话
    for (var chat in orgChatCache.openChats) {
      chat.isInterruption = trueOrNot;
    }
    messageController.update();
    update();

    // 同步会话
    await HubUtil().cacheChats(orgChatCache);
  }

  /// 删除个人空间所有聊天记录
  clearHistoryMsg() async {
    await HubUtil().clearHistoryMsg(spaceId, messageItemId);

    // 清空页面
    var chatSpaceId = chatController.spaceId;
    var chatMessageItemId = chatController.messageItemId;
    if (chatSpaceId == spaceId && messageItemId == chatMessageItemId) {
      chatController.details.clear();
    }

    var userId = auth.userId;

    var orgChatCache = messageController.orgChatCache;
    orgChatCache.chats.where((space) => space.id == userId).forEach((space) {
      for (var chat in space.chats) {
        if (chat.id == messageItemId) {
          chat.showTxt = null;
        }
      }
    });
    orgChatCache.recentChats
        ?.where((c) => c.spaceId == userId && c.id == messageItemId)
        .forEach((chat) {
      chat.showTxt = null;
    });
    messageController.update();

    // 同步会话
    await HubUtil().cacheChats(orgChatCache);
  }

  /// 删除好友
  removeFriends() async {
    // 接口删除好友
    var targetId = messageItem.id;
    await PersonApi.remove(targetId);
    await cacheRemove(auth.userId, targetId);
    messageController.update();
  }

  /// 退出群组
  exitGroup() async {
    var targetId = messageItem.id;
    await CohortApi.exit(targetId);
    await cacheRemove(spaceId, targetId);
    messageController.update();
  }

  // 清理缓存内容并同步信息
  cacheRemove(String spaceId, String targetId) async {
    var orgChatCache = messageController.orgChatCache;

    // 从缓存中删掉会话
    orgChatCache.chats.where((space) => space.id == spaceId).forEach((space) {
      space.chats.removeWhere((chat) => chat.id == targetId);
    });

    // 从近期删除会话
    orgChatCache.recentChats
        ?.removeWhere((chat) => chat.spaceId == spaceId && chat.id == targetId);

    // 从打开的会话删除
    orgChatCache.openChats
        .removeWhere((chat) => chat.spaceId == spaceId && chat.id == targetId);

    // 同步会话
    await HubUtil().cacheChats(orgChatCache);
  }
}
