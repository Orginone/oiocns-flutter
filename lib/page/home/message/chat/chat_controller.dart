import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/util/hub_util.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../api_resp/message_item_resp.dart';
import '../../../../api_resp/target_resp.dart';
import '../../../../enumeration/message_type.dart';
import '../message_controller.dart';

class ChatController extends GetxController {
  // 日志
  var log = Logger("ChatController");

  // 控制信息
  var homeController = Get.find<HomeController>();
  var messageController = Get.find<MessageController>();
  var messageText = TextEditingController();
  var messageScrollController = ItemScrollController();

  // 当前所在的群组
  late MessageItemResp messageItem;

  // 当前群所有人
  late Map<String, TargetResp> personMap;
  late List<TargetResp> personList;

  // 观测对象
  late List<MessageDetailResp> messageDetails;

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  // 初始化
  Future<void> init() async {
    // 获取参数
    messageItem = Get.arguments;

    // 清空所有聊天记录
    messageDetails = [];
    personMap = {};
    personList = [];
    update();

    // 初始化老数据个数，查询聊天记录的个数
    await getPersons();
    await getPageData();

    // 更新页面后，跳转到页面底部
    update();
    toBottom();
  }

  // 消息接收函數
  Future<void> onReceiveMessage(MessageDetailResp messageDetail) async {
    try {
      var messageDetailId = messageDetail.id;
      // if (!messageDetail.isWithdraw!) {
      //   // 如果不是撤回的话加入到会话当中
      //   var chatMessageDetail = ChatMessageDetail(
      //       messageItem, messageDetail, personMap[messageDetail.fromId]);
      //   messageDetails.add(chatMessageDetail);
      //   messageDetailMap[messageDetailId] = chatMessageDetail;
      // } else {
      //   if (messageDetailMap.containsKey(messageDetailId)) {
      //     // 如果存在这条单据详情的话
      //     ChatMessageDetail oldDetail = messageDetailMap[messageDetailId]!;
      //     oldDetail.isWithdraw.value = true;
      //     oldDetail.msgBody.value = messageDetail.msgBody ?? "";
      //   }
      // }
      //
      // // 改成已读状态
      // messageDetail.isRead = true;
      // await MessageDetailManager().update(messageDetail);

      // 滚动到最底
      toBottom();
    } catch (error) {
      error.printError();
    }
  }

  /// 查询群成员信息
  Future<void> getPersons() async {
    if (messageItem.typeName == "人员") {
      return;
    }
    int offset = 0;
    int limit = 100;
    String id = messageItem.id;
    while (true) {
      List<TargetResp> persons = await HubUtil().getPersons(id, limit, offset);
      personList.addAll(persons);
      if (persons.isEmpty) {
        break;
      }
      for (var person in persons) {
        personMap[person.id] = person;
        person.name = person.team.name;
        var typeName = person.typeName;
        typeName = typeName == "人员" ? "" : "[$typeName]";
        messageController.orgChatCache.nameMap[person.id] =
            "${person.name}$typeName";
      }
      offset += limit;
    }
    await HubUtil().cacheChats(messageController.orgChatCache);
  }

  /// 下拉时刷新旧的聊天记录
  Future<void> getPageData() async {
    String? spaceId = messageItem.spaceId;
    String sessionId = messageItem.id;
    String typeName = messageItem.typeName;

    List<MessageDetailResp> newDetails = await HubUtil()
        .getHistoryMsg(spaceId, sessionId, typeName, messageDetails.length, 30);
    messageDetails.addAll(newDetails);
  }

  // 发送消息至聊天页面
  Future<void> sendOneMessage() async {
    var groupId = messageController.currentMessageItemId;
    var spaceId = messageController.currentSpaceId;
    if (groupId == "-1") return;

    var value = messageText.value.text;
    if (value.isNotEmpty) {
      // toId 和 spaceId 都要是字符串类型
      var messageDetail = {
        "toId": groupId,
        "spaceId": spaceId,
        "msgType": MessageType.text.name,
        "msgBody": value
      };
      try {
        log.info("==> 发送的消息信息：$messageDetail");
        await HubUtil().sendMsg(messageDetail);

        // 清空聊天框内容
        messageText.clear();
      } catch (error) {
        error.printError();
      }
    }
  }

  // 滚动到页面底部
  void toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      messageScrollController.jumpTo(index: 0);
    });
  }
}
