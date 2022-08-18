import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_group_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/api_resp/user_resp.dart';
import 'package:orginone/model/message_detail_util.dart';
import 'package:orginone/obserable/latest_message.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../api_resp/api_resp.dart';
import '../../../config/constant.dart';
import '../../../model/db_model.dart';
import '../../../model/message_group_util.dart';
import '../../../model/message_item_util.dart';
import '../../../util/hub_util.dart';
import 'chat/chat_controller.dart';

/// 所有与后端消息交互的逻辑都先保存至数据库中再读取出来
class MessageController extends GetxController {
  var obs = false.obs;

  // 组的对象
  RxList<MessageGroup> messageGroups = <MessageGroup>[].obs;
  Map<int, MessageGroup> messageGroupMap = {};
  Map<int, RxList<MessageItem>> messageGroupItemsMap = {};

  var latestDetailMap = <int, LatestDetail>{};
  Map<int, MessageItem> messageItemMap = <int, MessageItem>{};

  var log = Logger("MessageController");

  // 参数
  var currentMessageItemId = -1;
  UserResp currentUser = HiveUtil().getValue(Keys.user);
  TargetResp currentUserInfo = HiveUtil().getValue(Keys.userInfo);

  // 组排序
  void sortingGroup(TargetResp highestPriority) {
    MessageGroup? matchGroup;
    for (var messageGroupItem in messageGroups) {
      if (messageGroupItem.id == highestPriority.id) {
        matchGroup = messageGroupItem;
      }
    }
    if (matchGroup != null) {
      messageGroups.remove(matchGroup);
      messageGroups.insert(0, matchGroup);
    }
  }

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
    // 读取聊天群
    Map<String, dynamic> chats = await HubUtil().getChats();

    // 聊天结果
    ApiResp apiResp = ApiResp.fromMap(chats);

    // 聊天数组
    List<dynamic> messageGroups = apiResp.data["groups"];

    // 事务控制
    await DbModel().batchStart();
    try {
      for (var item in messageGroups) {
        // 聊天组
        MessageGroupResp group = MessageGroupResp.fromMap(item);

        int groupExists = await MessageGroupUtil.count(group.id);

        if (groupExists == 0) {
          // 如果不存在这个群组就保存一下
          await MessageGroup(
                  account: currentUser.account,
                  id: group.id,
                  name: group.name,
                  isExpand: true)
              .save();
        }

        // 群聊天内容
        List<dynamic> messageItemList = item['chats'];
        for (var messageItemSingle in messageItemList) {
          MessageItem messageItem = MessageItem.fromMap(messageItemSingle);
          messageItem.msgGroupId = group.id;

          // 不存在的就保存
          int messageExists = await MessageItemUtil.count(
              messageItem.id!, messageItem.label ?? "");
          if (messageExists == 0) {
            messageItem.account = currentUser.account;
            await messageItem.save();
          }
        }
      }
      await DbModel().batchCommit();
    } catch (error) {
      // 初始化有问题直接回滚数据
      DbModel().batchRollback();
      return;
    }
  }

  Future<dynamic> initChats() async {
    messageGroups.clear();

    // 组装分组
    List<MessageGroup> groups = await MessageGroupUtil.getAllGroup();
    for (var group in groups) {
      var groupId = group.id!;
      messageGroupMap.putIfAbsent(groupId, () => group);
      messageGroupMap[groupId] = group;
      messageGroups.add(group);
      messageGroupItemsMap[groupId]?.clear();
    }

    // 聊天组
    List<MessageItem> items =
        await MessageItemUtil.getAllItems(currentUser.account);
    for (var messageItem in items) {
      var messageItemId = messageItem.id!;
      var groupId = messageItem.msgGroupId!;
      messageGroupItemsMap.putIfAbsent(groupId, () => <MessageItem>[].obs);
      messageGroupItemsMap[groupId]!.add(messageItem);

      // 最新的消息和未读的数量
      var message = await MessageDetailUtil.latestDetail(messageItemId);
      var createTime = message?.createTime;
      var notReadMessageCount =
          await MessageDetailUtil.notReadMessageCount(messageItemId);

      latestDetailMap[messageItemId] = LatestDetail(
          notReadMessageCount.obs,
          (message?.msgBody ?? Constant.emptyString).obs,
          (createTime == null
                  ? ""
                  : DateUtil.formatDate(createTime, format: "HH:mm:ss"))
              .obs);

      messageItemMap[messageItemId] = messageItem;
    }
  }

  // 更新聊天记录
  void updateChatItem(MessageDetail messageDetail) {
    var groupId = messageDetail.toId;
    if (latestDetailMap.containsKey(groupId)) {
      LatestDetail latestDetail = latestDetailMap[groupId]!;
      latestDetail.notReadCount.value += 1;
      latestDetail.msgBody.value = messageDetail.msgBody ?? "";
      latestDetail.createTime.value = messageDetail.createTime == null
          ? ""
          : DateUtil.formatDate(messageDetail.createTime, format: "HH:mm:ss");
    }
  }

  // 打开一个群组就阅读所有消息
  Future<void> messageItemRead() async {
    if (latestDetailMap.containsKey(currentMessageItemId)) {
      LatestDetail latestDetail = latestDetailMap[currentMessageItemId]!;
      latestDetail.notReadCount.value = 0;
    }
  }

  // 接受消息
  Future<void> onReceiveMessage(List<dynamic> messageList) async {
    if (messageList.isEmpty) return;
    try {
      for (var message in messageList) {
        var resp = ApiResp.fromMap(message);
        var messageDetail = MessageDetail.fromMap(resp.data);
        messageDetail.isRead = false;
        messageDetail.account = currentUser.account;
        try {
          // 保存消息
          await messageDetail.save();

          // // 更新群组的优先级
          // int fromId = messageDetail.fromId!;
          // if (!latestDetailMap.containsKey(fromId)) {
          //   // 保存新群组
          //   await getCharts();
          //
          //   // 获取群组，没有获取到的话就处理下一条信息
          //   MessageItem? newGroup = await MessageItem().getById(fromId);
          //   if (newGroup == null) continue;
          //
          //   // 加入到可观测对象中去
          //   messageItems.insert(0, newGroup);
          //   messageItemMap[fromId] = newGroup;
          //   latestDetailMap[fromId] = LatestDetail(
          //       1.obs,
          //       (messageDetail.msgBody ?? Constant.emptyString).obs,
          //       (messageDetail.createTime ?? DateTime.now()).obs);
          // }
          //
          // // 比对第一条，如果不是第一条，那么需要更新优先级
          // var itemItem = messageItems[0];
          // if (itemItem.id != fromId) {
          //   MessageItem messageItem = messageItemMap[fromId]!;
          //   await MessageItemManager().update(messageItem);
          //
          //   messageItems.remove(messageItem);
          //   messageItems.insert(0, messageItem);
          // }

          if (currentMessageItemId != -1) {
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
