import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/hub_util.dart';
import 'package:uuid/uuid.dart';

import '../../../../api_resp/message_item_resp.dart';
import '../../../../api_resp/target_resp.dart';
import '../../../../enumeration/message_type.dart';
import '../../../../enumeration/target_type.dart';
import '../message_controller.dart';

class ChatController extends GetxController {
  // 日志
  var log = Logger("ChatController");

  // 控制信息
  var homeController = Get.find<HomeController>();
  var messageController = Get.find<MessageController>();
  var messageScrollController = ScrollController();
  var messageScrollKey = "1024".obs;
  var uuid = const Uuid();

  // 当前所在的群组
  late MessageItemResp messageItem;
  late String spaceId;
  late String messageItemId;

  // 当前群所有人
  late RxString titleName;
  late Map<String, TargetResp> personMap;
  late Map<String, String> personNameMap;
  late List<TargetResp> personList;

  // 观测对象
  late List<MessageDetailResp> messageDetails;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    super.onClose();
    var orgChatCache = messageController.orgChatCache;
    var openChats = orgChatCache.openChats
        .where((chat) => chat.spaceId != spaceId || chat.id != messageItemId)
        .toList();
    orgChatCache.openChats = openChats;
    HubUtil().cacheChats(orgChatCache);
  }

  // 初始化
  Future<void> init() async {
    // 获取参数
    Map<String, dynamic> args = Get.arguments;
    messageItem = args["messageItem"];
    spaceId = args["spaceId"];
    messageItemId = args["messageItemId"];
    titleName = messageItem.name.obs;

    // 清空所有聊天记录
    messageDetails = [];
    personNameMap = {};
    personMap = {};
    personList = [];

    // 初始化老数据个数，查询聊天记录的个数
    await getPersons();
    await getHistoryMsg();
    titleName.value = getTitleName();
    update();

    // 处理缓存
    orgChatHandler();
  }

  // 消息接收函數
  void onReceiveMsg(
    String spaceId,
    String sessionId,
    MessageDetailResp? detail,
  ) {
    if (spaceId != this.spaceId && sessionId != messageItemId) {
      return;
    }
    if (detail == null) {
      return;
    }
    log.info("会话页面接收到一条新的数据${detail.toJson()}");
    if (detail.msgType == "recall") {
      for (var oldDetail in messageDetails) {
        if (oldDetail.id == detail.id) {
          oldDetail.msgBody = detail.msgBody;
          oldDetail.msgType = detail.msgType;
          oldDetail.createTime = detail.createTime;
        }
      }
    } else {
      int has = messageDetails.where((item) => item.id == detail.id).length;
      if (has == 0) {
        detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
        messageDetails.insert(0, detail);
      }
    }
    updateAndToBottom();
  }

  void orgChatHandler() {
    // 不存在就加入
    OrgChatCache orgChatCache = messageController.orgChatCache;
    orgChatCache.openChats = orgChatCache.openChats
        .where((item) => item.id != messageItemId || item.spaceId != spaceId)
        .toList();
    orgChatCache.openChats.add(messageItem);

    // 加入所有人员群缓存
    orgChatCache.nameMap.addAll(personNameMap);

    // 加入自己
    messageItem.noRead = 0;
    messageItem.personNum = personMap.length;
    messageController.update();

    HubUtil().cacheChats(messageController.orgChatCache);
  }

  /// 查询群成员信息
  Future<Map<String, String>> getPersons() async {
    if (messageItem.typeName == TargetType.person.name) {
      var name = await HubUtil().getName(messageItemId);
      personNameMap[messageItemId] = name;
      return personNameMap;
    }
    int offset = 0;
    int limit = 100;
    while (true) {
      List<TargetResp> persons =
          await HubUtil().getPersons(messageItemId, limit, offset);
      personList.addAll(persons);
      if (persons.isEmpty) {
        break;
      }
      for (var person in persons) {
        personMap[person.id] = person;
        var typeName = person.typeName;
        typeName = typeName == TargetType.person.name ? "" : "[$typeName]";
        personNameMap[person.id] = "${person.team?.name}$typeName";
      }
      offset += limit;
      if (persons.length < limit) {
        break;
      }
    }
    return personNameMap;
  }

  /// 下拉时刷新旧的聊天记录
  Future<void> getHistoryMsg() async {
    String typeName = messageItem.typeName;

    var insertPointer = messageDetails.length;
    List<MessageDetailResp> newDetails = await HubUtil()
        .getHistoryMsg(spaceId, messageItemId, typeName, insertPointer, 15);

    for (MessageDetailResp detail in newDetails) {
      messageDetails.insert(insertPointer, detail);
    }
  }

  // 发送消息至聊天页面
  void sendOneMessage(String value) {
    if (messageItemId == "-1") return;

    // toId 和 spaceId 都要是字符串类型
    if (value.isNotEmpty) {
      var messageDetail = {
        "toId": messageItemId,
        "spaceId": spaceId,
        "msgType": MessageType.text.name,
        "msgBody": EncryptionUtil.deflate(value)
      };
      try {
        log.info("====> 发送的消息信息：$messageDetail");
        HubUtil().sendMsg(messageDetail);
      } catch (error) {
        error.printError();
      }
    }
  }

  // 滚动到页面底部
  void updateAndToBottom() {
    if (messageScrollController.positions.isNotEmpty &&
        messageScrollController.offset != 0) {
      messageScrollKey.value = uuid.v4();
    }
    update();
  }

  /// 获取顶部群名称
  String getTitleName() {
    String itemName = messageItem.name;
    if (messageItem.typeName != TargetType.person.name) {
      itemName = "$itemName(${personList.length})";
    }
    return itemName;
  }
}
