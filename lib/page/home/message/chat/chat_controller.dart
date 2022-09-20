import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/util/hub_util.dart';

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
  var messageScrollController = ScrollController();

  // 当前所在的群组
  late MessageItemResp messageItem;
  late String spaceId;
  late String messageItemId;

  // 当前群所有人
  late Map<String, TargetResp> personMap;
  late List<TargetResp> personList;

  // 观测对象
  late List<MessageDetailResp> messageDetails;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // 初始化
  Future<void> init() async {
    // 获取参数
    Map<String, dynamic> args = Get.arguments;
    messageItem = args["messageItem"];
    spaceId = args["spaceId"];
    messageItemId = args["messageItemId"];

    // 清空所有聊天记录
    messageDetails = [];
    personMap = {};
    personList = [];

    // 初始化老数据个数，查询聊天记录的个数
    await getPersons();
    await getPageData();

    toBottom();
    update();
  }

  // 消息接收函數
  Future<void> onReceiveMessage(MessageDetailResp messageDetail) async {
    try {
      if (messageDetail.msgType == "recall") {
        for (var oldDetail in messageDetails) {
          if (oldDetail.id == messageDetail.id) {
            oldDetail.msgBody = messageDetail.msgBody;
            oldDetail.msgType = messageDetail.msgType;
            oldDetail.createTime = messageDetail.createTime;
          }
        }
      } else {
        messageDetails.add(messageDetail);
      }
      // 滚动到最底
      toBottom();
      update();
    } catch (error) {
      error.printError();
    }
  }

  /// 查询群成员信息
  Future<void> getPersons() async {
    messageController.spaceMessageItemMap[spaceId]?[messageItemId]?.noRead = 0;

    OrgChatCache orgChatCache = messageController.orgChatCache;
    if (messageItem.typeName == "人员") {
      if (!orgChatCache.nameMap.containsKey(messageItemId)) {
        var name = await HubUtil().getName(messageItemId);
        orgChatCache.nameMap[messageItemId] = name;
      }
      await HubUtil().cacheChats(orgChatCache);
      return;
    }
    int offset = 0;
    int limit = 100;
    while (true) {
      List<TargetResp> persons =
          await HubUtil().getPersons(messageItemId, limit, offset);
      personList.addAll(persons);
      if (persons.isEmpty || persons.length < limit) {
        break;
      }
      for (var person in persons) {
        personMap[person.id] = person;
        person.name = person.team.name;
        var typeName = person.typeName;
        typeName = typeName == "人员" ? "" : "[$typeName]";
        orgChatCache.nameMap[person.id] = "${person.name}$typeName";
      }
      offset += limit;
    }
    await HubUtil().cacheChats(orgChatCache);
  }

  /// 下拉时刷新旧的聊天记录
  Future<void> getPageData() async {
    String typeName = messageItem.typeName;

    List<MessageDetailResp> newDetails = await HubUtil().getHistoryMsg(
        spaceId, messageItemId, typeName, messageDetails.length, 15);
    messageDetails.insertAll(0, newDetails);
  }

  // 发送消息至聊天页面
  Future<void> sendOneMessage() async {
    if (messageItemId == "-1") return;

    var value = messageText.value.text;
    if (value.isNotEmpty) {
      // toId 和 spaceId 都要是字符串类型
      var messageDetail = {
        "toId": messageItemId,
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
      messageScrollController
          .jumpTo(messageScrollController.position.maxScrollExtent);
    });
  }
}
