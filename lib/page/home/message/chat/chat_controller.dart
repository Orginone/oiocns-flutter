import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/model/model.dart';
import 'package:orginone/model/user_info.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:orginone/util/hub_util.dart';

import 'component/chat_message_item.dart';
import '../../../../enumeration/enum_map.dart';
import '../../../../enumeration/message_type.dart';
import '../message_controller.dart';

class ChatController extends GetxController {
  // 控制信息
  var messageController = Get.find<MessageController>();
  var messageText = TextEditingController();
  var messageScrollController = ScrollController();

  // 分页信息
  var currentPage = 1;
  var pageSize = 20;
  int oldTotalCount = 0;
  UserInfo currentUserInfo = HiveUtil().getValue(Keys.userInfo);

  // 观测对象
  var messageItems = <Widget>[].obs;
  var title = "".obs;

  // 日志
  var logger = Logger("ChatController");

  @override
  void onInit() {
    logger.info("==============开始初始化聊天控制器=============");
    logger.info("===> 异步初始化聊天数据");
    init();
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
      var chatMessageItem = ChatMessageItem(messageDetail);
      messageItems.add(chatMessageItem);

      // 改成已读状态
      messageDetail.isRead = true;
      MessageDetailManager().update(messageDetail);

      // 滚动到最底部
      toBottom();
    } catch (error) {
      error.printError();
    }
  }

  // 初始化
  Future<void> init() async {
    // 清空所有聊天记录，指向当前聊天群
    messageItems.clear();

    // 查询聊天记录的个数
    var currentGroupId = messageController.currentGroupId;
    String countSQL =
        "SELECT COUNT(id) number FROM MessageDetail WHERE fromId = $currentGroupId OR toId = $currentGroupId";
    var res = await MessageDetailManager().execDataTable(countSQL);
    oldTotalCount = int.tryParse(res[0]["number"]!.toString())!;

    int totalPage = (oldTotalCount / pageSize).ceil();
    int remainder = oldTotalCount % pageSize;

    int offset = remainder + (totalPage - 1 - currentPage) * pageSize;
    offset = offset < 0 ? 0 : offset;
    int limit = pageSize;

    // 分页从数据库里读取最新的消息
    String querySQL =
        "SELECT * FROM messageDetail WHERE fromId = $currentGroupId OR toId = $currentGroupId LIMIT $limit OFFSET $offset";
    var messageList = await MessageDetailManager().execDataTable(querySQL);

    // 消息加入到列表上
    List<ChatMessageItem> temp = [];
    for (var message in messageList) {
      temp.add(ChatMessageItem(MessageDetail.fromMap(message)));
    }
    messageItems.insertAll(0, temp);

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
      messageScrollController
          .jumpTo(messageScrollController.position.maxScrollExtent);
    });
  }
}
