import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/model/message_detail_util.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/util/hub_util.dart';

import '../../../../api_resp/target_resp.dart';
import '../../../../enumeration/message_type.dart';
import '../../../../model/db_model.dart';
import '../../../../util/hive_util.dart';
import '../message_controller.dart';
import 'component/chat_message_detail.dart';

class ChatController extends GetxController {
  // 控制信息
  var messageController = Get.find<MessageController>();
  var homeController = Get.find<HomeController>();
  var messageText = TextEditingController();
  var messageScrollController = ScrollController();

  // 当前所在的群组
  late TargetRelation messageItem;
  TargetResp currentUserInfo = HiveUtil().getValue(Keys.userInfo);

  // 当前群所有人
  late Map<int, TargetResp> personMap;
  late List<TargetResp> personList;

  // 老数据分页信息
  var currentPage = 1;
  var pageSize = 20;
  int oldTotalCount = 0;
  int oldRemainder = 0;

  // 观测对象
  var messageDetails = <Widget>[].obs;

  // 日志
  var logger = Logger("ChatController");

  @override
  void onInit() async {
    logger.info("==============开始初始化聊天控制器=============");
    logger.info("===> 异步初始化聊天数据");
    await init();
    super.onInit();
    logger.info("==============结束初始化聊天控制器=============");
  }

  @override
  void onReady() async {
    // 阅读数据
    await messageItemRead();
    await messageController.messageItemRead();

    super.onReady();
  }

  @override
  void onClose() {
    logger.info("==============开始回收资源=============");
    // 清空数据
    messageDetails.clear();
    messageController.currentMessageItemId = -1;

    // 解除控制
    messageText.dispose();
    messageScrollController.dispose();
    super.onClose();
    logger.info("==============结束回收资源=============");
  }

  // 阅读信息
  Future<void> messageItemRead() async {
    await MessageDetailUtil.messageItemRead(
        messageController.currentMessageItemId);
  }

  // 消息接收函數
  Future<void> onReceiveMessage(MessageDetail messageDetail) async {
    try {
      var chatMessageDetail = ChatMessageDetail(
          messageItem, messageDetail, personMap[messageDetail.fromId]);
      messageDetails.add(chatMessageDetail);

      // 改成已读状态
      messageDetail.isRead = true;
      MessageDetailManager().update(messageDetail);

      // 滚动到最底
      toBottom();
    } catch (error) {
      error.printError();
    }
  }

  /// 刚进入页面时, 老数据的聊天总数
  Future<void> preCount() async {
    oldTotalCount = await MessageDetailUtil.getTotalCount(
        messageItem.activeTargetId!,
        messageItem.passiveTargetId!,
        messageItem.typeName ?? "未知");
    currentPage = (oldTotalCount / pageSize).ceil();
    oldRemainder = oldTotalCount % pageSize;
  }

  /// 查询群成员信息
  Future<void> getPersons() async {
    personMap = {};
    personList = [];
    var label = messageItem.label;
    if (label == "群组" || label == "公司") {
      List<TargetResp> persons =
          await HubUtil().getPersons(messageItem.passiveTargetId!, 1000, 0);
      if (persons.isNotEmpty) {
        for (var person in persons) {
          personMap[person.id] = person;
          personList.add(person);
        }
      }
    }
  }

  // 下拉时刷新旧的聊天记录
  Future<List<Map<String, Object?>>> pageData() async {
    int offset = oldRemainder + (currentPage - 2) * pageSize;
    offset = offset < 0 ? 0 : offset;

    if(messageItem.passiveTargetId == currentUserInfo.id) {
      return  await MessageDetailUtil.myPageData(
          offset,
          pageSize,
          messageController.currentSpaceId,
          messageController.currentMessageItemId,
          messageItem.typeName ?? "未知");
    }

    // 列表
    return  await MessageDetailUtil.pageData(
        offset,
        pageSize,
        messageController.currentSpaceId,
        messageController.currentMessageItemId,
        messageItem.typeName ?? "未知");
  }

  // 获取数据并渲染到页面
  Future<void> getPageDataAndRender() async {
    var messageList = await pageData();
    List<ChatMessageDetail> temp = [];
    for (var message in messageList) {
      var messageDetail = MessageDetail.fromMap(message);
      temp.add(ChatMessageDetail(
          messageItem, messageDetail, personMap[messageDetail.fromId]));
    }
    messageDetails.insertAll(0, temp);
  }

  // 初始化
  Future<void> init() async {
    // 清空所有聊天记录，指向当前聊天群
    messageDetails.clear();

    // 初始化群組
    messageItem = messageController.messageGroupItemMap[messageController
        .currentSpaceId]![messageController.currentMessageItemId]!;

    // 初始化老数据个数，查询聊天记录的个数
    await getPersons();
    await preCount();
    await getPageDataAndRender();

    // 跳转到页面底部
    toBottom();
  }

  // 发送消息至聊天页面
  Future<void> sendOneMessage() async {
    var groupId = messageController.currentMessageItemId;
    var spaceId = messageController.currentSpaceId;
    if (groupId == -1) return;

    var value = messageText.value.text;
    if (value.isNotEmpty) {
      // toId 和 spaceId 都要是字符串类型
      var messageDetail = {
        "toId": "$groupId",
        "spaceId": "$spaceId",
        "msgType": MessageType.text.name,
        "msgBody": value
      };
      try {
        logger.info("==> 发送的消息信息：$messageDetail");
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
      messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.ease);
    });
  }
}
