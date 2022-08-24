import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_group_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/api_resp/user_resp.dart';
import 'package:orginone/model/message_detail_util.dart';
import 'package:orginone/model/target_relation_util.dart';
import 'package:orginone/model/user_space_relation_util.dart';
import 'package:orginone/obserable/latest_message.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../api_resp/api_resp.dart';
import '../../../model/db_model.dart';
import '../../../util/hub_util.dart';
import 'chat/chat_controller.dart';

/// 所有与后端消息交互的逻辑都先保存至数据库中再读取出来
class MessageController extends GetxController {
  // 组的对象
  Map<int, UserSpaceRelation> messageGroupMap = {};
  RxList<UserSpaceRelation> messageGroups = <UserSpaceRelation>[].obs;

  // 会话对象和索引
  Map<int, Map<int, TargetRelation>> messageGroupItemMap =
      <int, Map<int, TargetRelation>>{};
  Map<int, RxList<TargetRelation>> messageGroupItemsMap = {};
  Map<int, int> notFindItemMap = {};

  // 最新消息对象
  var latestDetailMap = <int, Map<int, LatestDetail>>{};

  // 日志对象
  var log = Logger("MessageController");

  // 参数
  int currentSpaceId = -1;
  int currentMessageItemId = -1;
  UserResp currentUser = HiveUtil().getValue(Keys.user);
  TargetResp currentUserInfo = HiveUtil().getValue(Keys.userInfo);

  @override
  void onInit() async {
    // 连接成功后初始化聊天面板信息，
    await firstInitChartsData();
    await initChats();

    super.onInit();
  }

  // 组排序
  void sortingGroup(TargetResp highestPriority) {
    UserSpaceRelation? matchGroup;
    for (var messageGroupItem in messageGroups) {
      if (messageGroupItem.targetId == highestPriority.id) {
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
        // 聊天组, 存在就更新, 不存在就插入
        MessageGroupResp groupResp = MessageGroupResp.fromMap(item);

        await groupResp.toTarget().upsert();
        await UserSpaceRelation(
                account: currentUser.account, targetId: groupResp.id, name: groupResp.name, isExpand: true)
            .upsert();

        // 群聊天内容
        List<dynamic> messageItemList = item['chats'];

        for (var messageItemSingle in messageItemList) {
          TargetRelation messageItem =
              TargetRelation.fromMap(messageItemSingle);
          messageItem.activeTargetId = groupResp.id;
          messageItem.passiveTargetId = int.tryParse(messageItemSingle["id"].toString());
          messageItem.priority = HiveUtil().groupPriorityAddAndGet();

          await messageItem.upsert();
        }
      }
      await DbModel().batchCommit();
    } catch (error) {
      error.printError();
      // 初始化有问题直接回滚数据
      DbModel().batchRollback();
      return;
    }
  }

  // 组装分组
  Future<dynamic> initGroup(int groupId) async {
    if (!messageGroupMap.containsKey(groupId)) {
      UserSpaceRelation? messageGroup =
          await UserSpaceRelationUtil.getById(groupId);
      if (messageGroup == null) return;

      messageGroupMap[groupId] = messageGroup;
      messageGroups.add(messageGroup);
    }
  }

  // 具体会话
  Future<dynamic> initChats() async {
    List<TargetRelation> items = await TargetRelationUtil.getAllItems();
    for (TargetRelation messageItem in items) {
      if (messageItem.activeTargetId == null ||
          messageItem.passiveTargetId == null) continue;

      await initGroup(messageItem.activeTargetId!);
      await obxNewItem(messageItem);
    }
  }

  Future<dynamic> obxNewItem(TargetRelation messageItem) async {
    // 先建立组
    var messageItemId = messageItem.passiveTargetId!;
    var groupId = messageItem.activeTargetId ?? currentUserInfo.id;

    // 创建群的可观测对象和索引
    messageGroupItemMap.putIfAbsent(groupId, () => {});
    messageGroupItemsMap.putIfAbsent(groupId, () => <TargetRelation>[].obs);

    // 查看当前群里是否有会话 ID，没有的话就加一个进去，形成可观察对象
    var messageGroupItem = messageGroupItemMap[groupId]!;
    var messageGroupItems = messageGroupItemsMap[groupId]!;

    await obxNewItemDetail(messageItem);
    if (!messageGroupItem.containsKey(messageItemId)) {
      messageGroupItem[messageItemId] = messageItem;
      messageGroupItems.add(messageItem);
    }
  }

  // 最新的消息和未读的数量，以及时间
  Future<dynamic> obxNewItemDetail(TargetRelation messageItem) async {
    var messageItemId = messageItem.passiveTargetId!;
    int groupId = messageItem.activeTargetId!;

    // 每一条会话形成可观测对象
    latestDetailMap.putIfAbsent(groupId, () => {});
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
          (messageDetail?.msgBody ?? "").obs,
          (createTime == null
                  ? ""
                  : DateUtil.formatDate(createTime, format: "HH:mm:ss"))
              .obs);
    } else {
      updateChatItem(messageItem, messageDetail);
    }
  }

  // 更新聊天记录
  void updateChatItem(
      TargetRelation? messageItem, MessageDetail? messageDetail) {
    if (messageItem == null) return;
    if (messageItem.passiveTargetId == null) return;
    if (messageDetail == null) return;
    if (messageDetail.spaceId == null) return;
    if (messageDetail.fromId == null) return;
    if (messageDetail.toId == null) return;

    int spaceId = messageDetail.spaceId!;
    int itemId = messageItem.passiveTargetId!;

    latestDetailMap.putIfAbsent(spaceId, () => {});
    var latestDetailItemMap = latestDetailMap[spaceId];

    if (latestDetailItemMap!.containsKey(itemId)) {
      LatestDetail latestDetail = latestDetailItemMap[itemId]!;
      if (messageDetail.fromId != currentUserInfo.id ||
          (currentMessageItemId != -1 && currentMessageItemId != itemId)) {
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
        var messageDetail = MessageDetail.fromMap(message);

        var spaceId = messageDetail.spaceId;
        var fromId = messageDetail.fromId;
        var toId = messageDetail.toId;

        try {
          // 确定空间
          if (!messageGroupItemMap.containsKey(spaceId)) {
            var itemMap = messageGroupItemMap[currentUserInfo.id]!;
            if (itemMap.containsKey(spaceId)) {
              spaceId = currentUserInfo.id;
            } else {
              // 如果还是找不到，就丢了
              continue;
            }
          }

          // 匹配群
          Map<int, TargetRelation> messageItemMap =
              messageGroupItemMap[spaceId]!;
          RxList<TargetRelation> messageItems = messageGroupItemsMap[spaceId]!;
          TargetRelation? currentMessageItem = messageItemMap[toId];
          for (var messageItem in messageItems) {
            if (messageItem.typeName == "人员" &&
                fromId == messageItem.passiveTargetId &&
                fromId != currentUserInfo.id &&
                toId == currentUserInfo.id) {
              currentMessageItem = messageItem;
              break;
            }
          }
          if (currentMessageItem == null) {
            continue;
          }

          // 更换位置, 更新优先级
          messageItems.remove(currentMessageItem);
          messageItems.insert(0, currentMessageItem);
          currentMessageItem.priority = HiveUtil().groupPriorityAddAndGet();
          await TargetRelationManager().update(currentMessageItem);

          // 保存消息
          messageDetail.isRead = false;
          messageDetail.account = currentUser.account;
          messageDetail.spaceId = spaceId;
          messageDetail.typeName = currentMessageItem.typeName;
          await messageDetail.save();

          if (currentMessageItemId == currentMessageItem.passiveTargetId) {
            // 如果当前在聊天页面当中就接受消息
            ChatController chatController = Get.find();
            await chatController.onReceiveMessage(messageDetail);
          }

          // 更新聊天列表的视图
          updateChatItem(currentMessageItem, messageDetail);
        } catch (error) {
          error.printError();
        }
      }
    } catch (error) {
      error.printError();
    }
  }
}
