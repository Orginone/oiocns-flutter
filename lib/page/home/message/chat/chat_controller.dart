import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/util/hub_util.dart';

import '../../../../enumeration/message_type.dart';
import '../../../../model/db_model.dart';
import '../message_controller.dart';
import 'component/chat_message_item.dart';

class ChatController extends GetxController {
  // 控制信息
  var messageController = Get.find<MessageController>();
  var messageText = TextEditingController();
  var messageScrollController = ScrollController();

  // 老数据分页信息
  late MessageItem messageItem;
  var currentPage = 1;
  var pageSize = 20;
  int oldTotalCount = 0;
  int oldRemainder = 0;

  // 观测对象
  var messageItems = <Widget>[].obs;

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
    await groupRead();
    await messageController.groupRead();

    super.onReady();
  }

  @override
  void onClose() {
    logger.info("==============开始回收资源=============");
    // 清空数据
    messageItems.clear();
    messageController.currentGroupId = -1;

    // 解除控制
    messageText.dispose();
    messageScrollController.dispose();
    super.onClose();
    logger.info("==============结束回收资源=============");
  }

  // 阅读信息
  Future<void> groupRead() async {
    int groupId = messageController.currentGroupId;

    String updateSql =
        "UPDATE MessageDetail SET isRead = 1 WHERE fromId =$groupId";
    await MessageDetailManager().execSQL(updateSql);
  }

  // 消息接收函數
  Future<void> onReceiveMessage(MessageDetail messageDetail) async {
    try {
      var chatMessageItem = ChatMessageItem(messageItem, messageDetail);
      messageItems.add(chatMessageItem);

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
    String countSQL =
        "SELECT COUNT(id) number FROM MessageDetail WHERE fromId = ${messageController.currentGroupId} OR toId = ${messageController.currentGroupId}";
    var res = await MessageDetailManager().execDataTable(countSQL);
    oldTotalCount = int.tryParse(res[0]["number"]!.toString())!;
    currentPage = (oldTotalCount / pageSize).ceil();
    oldRemainder = oldTotalCount % pageSize;
  }

  // 下拉时刷新旧的聊天记录
  Future<List<Map<String, Object?>>> pageData() async {
    int offset = oldRemainder + (currentPage - 2) * pageSize;
    offset = offset < 0 ? 0 : offset;

    // 列表
    String querySQL =
        "SELECT * FROM messageDetail WHERE "
        "fromId = ${messageController.currentGroupId} OR toId = ${messageController.currentGroupId} "
        "LIMIT $pageSize OFFSET $offset";
    return await MessageDetailManager().execDataTable(querySQL);
  }

  // 获取数据并渲染到页面
  Future<void> getPageDataAndRender() async {
    var messageList = await pageData();
    List<ChatMessageItem> temp = [];
    for (var message in messageList) {
      temp.add(ChatMessageItem(messageItem, MessageDetail.fromMap(message)));
    }
    messageItems.insertAll(0, temp);
  }

  // 初始化
  Future<void> init() async {
    // 清空所有聊天记录，指向当前聊天群
    messageItems.clear();

    // 初始化群組
    messageItem =
        messageController.messageItemMap[messageController.currentGroupId]!;

    // 初始化老数据个数，查询聊天记录的个数
    await preCount();
    await getPageDataAndRender();

    // 跳转到页面底部
    toBottom();
  }

  // 发送消息至聊天页面
  Future<void> sendOneMessage() async {
    var groupId = messageController.currentGroupId;
    if (groupId == -1) return;

    var value = messageText.value.text;
    if (value.isNotEmpty) {
      var messageDetail = {
        "toId": "$groupId",
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
