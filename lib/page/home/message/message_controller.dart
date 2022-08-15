import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/model/message_count.dart';
import 'package:orginone/model/user.dart';
import 'package:orginone/obserable/latest_message.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:orginone/util/sqlite_util.dart';

import '../../../config/constant.dart';
import '../../../model/api_resp.dart';
import '../../../model/model.dart';
import '../../../model/user_info.dart';
import '../../../util/hub_util.dart';
import 'chat/chat_controller.dart';

/// 所有与后端消息交互的逻辑都先保存至数据库中再读取出来
class MessageController extends GetxController {
  // 观测对象
  RxList<MessageGroup> groupItems = <MessageGroup>[].obs;
  var latestGroupMessageMap = <int, LatestMessage>{};
  Map<int, MessageGroup> groupMap = <int, MessageGroup>{};

  var log = Logger("MessageController");

  // 参数
  var currentGroupId = -1;
  User currentUser = HiveUtil().getValue(Keys.user);
  UserInfo currentUserInfo = HiveUtil().getValue(Keys.userInfo);

  Future<dynamic> firstInitChartsData() async {
    var hiveUtil = HiveUtil();
    var isInitChat = hiveUtil.getValue(Keys.isInitChat) ?? false;
    if (isInitChat) return;

    try {
      await getCharts();
      hiveUtil.putValue(Keys.isInitChat, true);
    } catch (error) {
      error.printError();
    }
  }

  Future<dynamic> getCharts() async {
    var sqliteUtil = SqliteUtil();

    // 读取聊天群
    Map<String, dynamic> chats = await HubUtil().getChats();

    // 聊天结果
    ApiResp apiResp = ApiResp.fromJson(chats);

    // 聊天数组
    MessageCount messageCount = MessageCount.fromJson(apiResp.data);

    // 事务控制
    await sqliteUtil.orginone.batchStart();
    try {
      for (var item in messageCount.result) {
        // 聊天群
        MessageGroup group = MessageGroup.fromMap(item);
        int groupExists = await MessageGroup()
            .select(columnsToSelect: ["COUNT(id)"])
            .id
            .equals(group.id)
            .page(1, 1)
            .toCount();

        if (groupExists == 0) {
          // 如果不存在这个群组就保存一下
          group.priority = HiveUtil().groupPriorityAddAndGet();
          await group.save();
        }

        // 最新消息内容
        var messageMap = item['message'];
        if (messageMap != null) {
          MessageDetail message = MessageDetail.fromMap(messageMap);
          int messageExists = await MessageDetail()
              .select(columnsToSelect: ["COUNT(id)"])
              .id
              .equals(message.id)
              .page(1, 1)
              .toCount();

          if (messageExists == 0) {
            await message.save();
          }
        }
      }
      await sqliteUtil.orginone.batchCommit();
    } catch (error) {
      // 初始化有问题直接回滚数据
      sqliteUtil.orginone.batchRollback();
      return;
    }
  }

  Future<dynamic> initChats() async {
    groupItems.clear();

    var groups = await MessageGroup().select().orderByDesc("priority").toList();

    for (int i = 0; i < groups.length; i++) {
      var group = groups[i];
      var groupId = group.id;
      if (groupId == null) continue;

      var message = await MessageDetail()
          .select(columnsToSelect: ["msgBody", "createTime"])
          .toId
          .equals(groupId)
          .orderByDesc("seqId")
          .page(1, 1)
          .toSingle();

      var notReadMessageCount = await MessageDetail()
          .select(columnsToSelect: ["COUNT(id)"])
          .fromId
          .equals(groupId)
          .and
          .isRead
          .equals(false)
          .toCount();

      latestGroupMessageMap[groupId] = LatestMessage(
          notReadMessageCount.obs,
          (message?.msgBody ?? Constant.emptyString).obs,
          (message?.createTime ?? DateTime.now()).obs);

      groupItems.add(group);
      groupMap[groupId] = group;
    }
  }

  // 更新聊天记录
  void updateChatItem(MessageDetail messageDetail) {
    var groupId = messageDetail.fromId;
    if (latestGroupMessageMap.containsKey(groupId)) {
      LatestMessage latestGroupMessage = latestGroupMessageMap[groupId]!;
      latestGroupMessage.notReadCount.value += 1;
      latestGroupMessage.msgBody.value = messageDetail.msgBody ?? "";
      latestGroupMessage.createTime.value =
          messageDetail.createTime ?? DateTime.now();
    }
  }

  // 打开一个群组就阅读所有消息
  Future<void> groupRead() async {
    if (latestGroupMessageMap.containsKey(currentGroupId)) {
      LatestMessage latestGroupMessage = latestGroupMessageMap[currentGroupId]!;
      latestGroupMessage.notReadCount.value = 0;
    }
  }

  // 接受消息
  Future<void> onReceiveMessage(List<dynamic> messageList) async {
    if (messageList.isEmpty) return;
    try {
      for (var message in messageList) {
        var resp = ApiResp.fromJson(message);
        var messageDetail = MessageDetail.fromMap(resp.data);
        messageDetail.isRead = false;
        try {
          // 保存消息
          await messageDetail.save();

          // 更新群组的优先级
          int fromId  = messageDetail.fromId!;
          if (!latestGroupMessageMap.containsKey(fromId)) {
            // 保存新群组
            await getCharts();

            // 获取群组，没有获取到的话就处理下一条信息
            MessageGroup? newGroup = await MessageGroup().getById(fromId);
            if (newGroup == null) continue;

            // 加入到可观测对象中去
            groupItems.insert(0, newGroup);
            groupMap[fromId] = newGroup;
            latestGroupMessageMap[fromId] = LatestMessage(
                1.obs,
                (messageDetail.msgBody ?? Constant.emptyString).obs,
                (messageDetail.createTime ?? DateTime.now()).obs);
          }

          // 比对第一条，如果不是第一条，那么需要更新优先级
          var groupItem = groupItems[0];
          if (groupItem.id != fromId) {
            var tempGroup = groupMap[fromId];
            tempGroup!.priority = HiveUtil().groupPriorityAddAndGet();
            await MessageGroupManager().update(tempGroup);

            groupItems.remove(tempGroup);
            groupItems.insert(0, tempGroup);
          }

          if (currentGroupId != -1) {
            // 如果当前在聊天页面当中就接受消息
            ChatController chatController = Get.find();
            await chatController.onReceiveMessage(messageDetail);
          }

          // 更新聊天列表的视图
          updateChatItem(messageDetail);
        } catch (error) {
          error.printError();
        }
      }
    } catch (error) {
      error.printError();
    }
  }
}
