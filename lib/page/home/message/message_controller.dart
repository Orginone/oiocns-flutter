import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_group_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/api_resp/user_resp.dart';
import 'package:orginone/model/message_detail_util.dart';
import 'package:orginone/obserable/latest_message.dart';
import 'package:orginone/page/home/home_controller.dart';
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
  // 组的对象
  Map<int, MessageGroup> messageGroupMap = {};
  RxList<MessageGroup> messageGroups = <MessageGroup>[].obs;
  Map<int, Map<int, MessageItem>> messageGroupItemMap =
      <int, Map<int, MessageItem>>{};
  Map<int, RxList<MessageItem>> messageGroupItemsMap = {};
  var latestDetailMap = <int, Map<int, LatestDetail>>{};

  // 日志对象
  var log = Logger("MessageController");

  // 参数
  int currentSpaceId = -1;
  int currentMessageItemId = -1;
  UserResp currentUser = HiveUtil().getValue(Keys.user);
  TargetResp currentUserInfo = HiveUtil().getValue(Keys.userInfo);

  // 主页控制器
  late HomeController homeController = Get.find<HomeController>();

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

  // 组装分组
  Future<dynamic> initGroups() async {
    List<MessageGroup> groups = await MessageGroupUtil.getAllGroup();
    for (var group in groups) {
      var groupId = group.id;
      if (groupId == null) continue;

      if (!messageGroupMap.containsKey(groupId)) {
        messageGroupMap[groupId] = group;
        messageGroups.add(group);
        latestDetailMap.putIfAbsent(groupId, () => {});
      }
    }
  }

  // 具体会话
  Future<dynamic> initChats() async {
    List<MessageItem> items = await MessageItemUtil.getAllItems();
    for (var messageItem in items) {
      if (messageItem.msgGroupId == null || messageItem.id == null) continue;

      await obxNewItem(messageItem);
      await obxNewItemDetail(messageItem.msgGroupId!, messageItem.id!);
    }
  }

  // 最新的消息和未读的数量，以及时间
  Future<dynamic> obxNewItemDetail(int groupId, int messageItemId) async {
    // 每一条会话形成可观测对象
    var detailMap = latestDetailMap[groupId]!;

    var messageDetail =
        await MessageDetailUtil.latestDetail(groupId, messageItemId);
    var notReadMCount =
        await MessageDetailUtil.notReadMessageCount(messageItemId);
    var createTime = messageDetail?.createTime;

    if (!detailMap.containsKey(messageItemId)) {
      // 不存在就创建
      detailMap[messageItemId] = LatestDetail(
          notReadMCount.obs,
          (messageDetail?.msgBody ?? Constant.emptyString).obs,
          (createTime == null
                  ? ""
                  : DateUtil.formatDate(createTime, format: "HH:mm:ss"))
              .obs);
    } else {
      updateChatItem(messageDetail);
    }
  }

  Future<dynamic> obxNewItem(MessageItem messageItem) async {
    // 先建立组
    var messageItemId = messageItem.id!;
    var groupId = messageItem.msgGroupId ?? currentUserInfo.id;

    // 创建群的可观测对象和索引
    messageGroupItemMap.putIfAbsent(groupId, () => {});
    messageGroupItemsMap.putIfAbsent(groupId, () => <MessageItem>[].obs);

    // 查看当前群里是否有会话 ID，没有的话就加一个进去，形成可观察对象
    var messageGroupItem = messageGroupItemMap[groupId]!;
    var messageGroupItems = messageGroupItemsMap[groupId]!;
    if (!messageGroupItem.containsKey(messageItemId)) {
      messageGroupItem[messageItemId] = messageItem;
      messageGroupItems.insert(0, messageItem);
    }
  }

  // 更新聊天记录
  void updateChatItem(MessageDetail? messageDetail) {
    if (messageDetail == null) return;
    if (messageDetail.fromId == null) return;

    int spaceId = messageDetail.spaceId ?? currentUserInfo.id;
    int itemId = messageDetail.fromId!;

    latestDetailMap.putIfAbsent(spaceId, () => {});
    var messageGroup = latestDetailMap[spaceId];

    if (messageGroup!.containsKey(itemId)) {
      LatestDetail latestDetail = messageGroup[itemId]!;
      if (messageDetail.fromId != currentUserInfo.id) {
        // 如果是我自己发的，那就不更新视图条数了
        latestDetail.notReadCount.value += 1;
      }
      latestDetail.msgBody.value = messageDetail.msgBody ?? "";
      latestDetail.createTime.value = messageDetail.createTime == null
          ? ""
          : DateUtil.formatDate(messageDetail.createTime, format: "HH:mm:ss");
    }
  }

  // 打开一个群组就阅读所有消息
  Future<void> messageItemRead() async {
    if (latestDetailMap.containsKey(currentSpaceId)) {
      var groupMap = latestDetailMap[currentSpaceId]!;
      if (groupMap.containsKey(currentMessageItemId)) {
        LatestDetail latestDetail = groupMap[currentMessageItemId]!;
        latestDetail.notReadCount.value = 0;
      }
    }
  }

  // 接受消息
  Future<void> onReceiveMessage(List<dynamic> messageList) async {
    if (messageList.isEmpty) return;
    try {
      for (var message in messageList) {
        var resp = ApiResp.fromMap(message);
        var messageDetail = MessageDetail.fromMap(resp.data);

        // 没有空间 ID 的就抛到我的会话中
        var spaceId = messageGroupMap.containsKey(messageDetail.spaceId)
            ? messageDetail.spaceId
            : currentUserInfo.id;

        try {
          // 保存消息
          messageDetail.isRead = false;
          messageDetail.account = currentUser.account;
          messageDetail.spaceId = spaceId;
          await messageDetail.save();

          // 更新页面信息
          //  int fromId = messageDetail.fromId!;
          // if (!messageGroupItemMap.containsKey(spaceId) ||
          //     !messageGroupItemMap[spaceId]!.containsKey(fromId)) {
          //   // 如果这个群组和会话不存在，动态的加入
          //   await getCharts();
          //   await initChats();
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
