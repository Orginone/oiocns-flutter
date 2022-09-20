import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/util/any_store_util.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../api_resp/message_detail_resp.dart';
import '../../../api_resp/message_item_resp.dart';
import '../../../util/hub_util.dart';
import 'chat/chat_controller.dart';

/// 所有与后端消息交互的逻辑都先保存至数据库中再读取出来
class MessageController extends GetxController {
  // 日志对象
  Logger log = Logger("MessageController");

  // 参数
  OrgChatCache orgChatCache = OrgChatCache.empty();

  // 会话索引
  Map<String, SpaceMessagesResp> spaceMap = {};
  Map<String, Map<String, MessageItemResp>> spaceMessageItemMap = {};

  @override
  void onInit() async {
    // 连接成功后初始化聊天面板信息，
    await _subscribingCharts();
    super.onInit();
  }

  void sortingGroup(TargetResp highestPriority) {
    // 匹配会话空间
    SpaceMessagesResp? matchSpace;
    var spaces = orgChatCache.chats;
    for (SpaceMessagesResp space in spaces) {
      var isCurrentSpace = space.id == highestPriority.id;
      space.isExpand = isCurrentSpace;
      if (isCurrentSpace) {
        matchSpace = space;
        break;
      }
    }
    if (matchSpace != null) {
      // 重新排序
      spaces.remove(matchSpace);
      spaces.insert(0, matchSpace);
    }
    update();
  }

  @Deprecated("废弃，新会话从缓存中拿")
  Future<dynamic> getCharts() async {
    // 读取聊天群
    List<SpaceMessagesResp> messageGroups = await HubUtil().getChats();
    _spaceHandling(messageGroups);

    // 空间排序
    HomeController homeController = Get.find<HomeController>();
    sortingGroup(homeController.currentSpace);

    // 更新视图
    update();

    // 缓存消息
    orgChatCache.chats = messageGroups;
    await HubUtil().cacheChats(orgChatCache);
  }

  /// 空间处理
  _spaceHandling(List<SpaceMessagesResp> messageGroups) {
    // 清空数组
    spaceMap.clear();
    spaceMessageItemMap.clear();

    // 处理数组
    var homeController = Get.find<HomeController>();
    List<SpaceMessagesResp> spaces = [];
    for (var messageGroup in messageGroups) {
      if (messageGroup.id == homeController.currentSpace.id) {
        messageGroup.isExpand = true;
        spaces.insert(0, messageGroup);
      } else {
        spaces.add(messageGroup);
      }
      spaceMap[messageGroup.id] = messageGroup;

      // 排序
      List<MessageItemResp> chats = messageGroup.chats;
      chats.sort((first, second) => -first.msgTime.compareTo(second.msgTime));

      // 建立索引
      spaceMessageItemMap[messageGroup.id] = {};
      for (MessageItemResp messageItem in chats) {
        spaceMessageItemMap[messageGroup.id]![messageItem.id] = messageItem;
      }
    }
    orgChatCache.chats = spaces;
  }

  /// 订阅聊天群变动
  _subscribingCharts() {
    SubscriptionKey key = SubscriptionKey.orgChat;
    String domain = Domain.user.name;
    AnyStoreUtil().subscribing(key, domain, _updateChats);
  }

  /// 从订阅通道拿到的数据直接更新试图
  _updateChats(Map<String, dynamic> data) {
    orgChatCache = OrgChatCache(data);
    _spaceHandling(orgChatCache.chats);
    update();
  }

  /// 接受消息
  Future<void> onReceiveMessage(List<dynamic> messageList) async {
    if (messageList.isEmpty) {
      return;
    }
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    for (var message in messageList) {
      log.info("接收到一条新的消息$message");
      var messageDetail = MessageDetailResp.fromMap(message);

      // 空间转换
      if (messageDetail.spaceId == null ||
          messageDetail.spaceId == messageDetail.fromId) {
        messageDetail.spaceId = userInfo.id;
      }

      var spaceId = messageDetail.spaceId;
      var fromId = messageDetail.fromId;
      var toId = messageDetail.toId;
      var sessionId = toId;

      try {
        // 确定空间
        if (!spaceMap.containsKey(spaceId)) {
          continue;
        }

        // 匹配群
        SpaceMessagesResp space = spaceMap[spaceId]!;
        for (var chat in space.chats) {
          if (chat.typeName == "人员" &&
              fromId == chat.id &&
              toId == userInfo.id) {
            sessionId = fromId;
          }
        }

        // 对象
        MessageItemResp? item = spaceMessageItemMap[spaceId]?[sessionId];
        if (item == null) {
          continue;
        }

        if (spaceId == userInfo.id) {
          // 如果是个人空间，存储一下信息
          await HubUtil().cacheMsg(sessionId, messageDetail);
        }
        item.msgBody = messageDetail.msgBody;
        item.msgTime = messageDetail.createTime ?? DateTime.now();
        item.msgType = messageDetail.msgType;
        if (item.msgType == "recall") {
          item.showText = messageDetail.msgBody?.contains("<img>") ?? false
              ? "[图片]"
              : messageDetail.msgBody;
        } else {
          item.showText = messageDetail.msgBody;
        }
        if (item.typeName != "人员") {
          item.showText =
              "${orgChatCache.nameMap[messageDetail.fromId]}：${item.showText}";
        }

        ChatController chatController = Get.find();
        // if (currentSpaceId == spaceId && currentMessageItemId == sessionId) {
        //   // 如果当前正在会话中
        //   ChatController chatController = Get.find();
        //   await chatController.onReceiveMessage(messageDetail);
        // } else {
        //   // 如果不在会话中
        //
        // }
        item.noRead = (item.noRead ?? 0) + 1;
        orgChatCache.messageDetail = messageDetail;
        orgChatCache.target = item;

        // 更新试图
        update();

        // 缓存会话
        HubUtil().cacheChats(orgChatCache);
      } catch (error) {
        log.info("接收消息异常:$error");
      }
    }
  }
}
