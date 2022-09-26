import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
class MessageController extends GetxController with WidgetsBindingObserver {
  // 日志对象
  Logger log = Logger("MessageController");

  // 参数
  OrgChatCache orgChatCache = OrgChatCache.empty();

  // 会话索引
  Map<String, SpaceMessagesResp> spaceMap = {};
  Map<String, Map<String, MessageItemResp>> spaceMessageItemMap = {};

  // 当前 app 状态
  AppLifecycleState? currentAppState;

  @override
  void onInit() async {
    super.onInit();
    // 监听页面的生命周期
    WidgetsBinding.instance.addObserver(this);
    // 订阅聊天面板信息
    await _subscribingCharts();
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
    _latestMsgHandling(orgChatCache.messageDetail);
    update();
  }

  /// 最新的消息处理
  _latestMsgHandling(MessageDetailResp? detail) {
    if (detail == null) {
      return;
    }
    if (Get.isRegistered<ChatController>()) {
      // 消息预处理
      TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
      String sessionId = _msgPreHandler(detail, userInfo);

      ChatController chatController = Get.find<ChatController>();
      chatController.onReceiveMsg(detail.spaceId!, sessionId, detail);
    }
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
      chats.sort((first, second) {
        if (first.msgTime == null || second.msgTime == null) {
          return 0;
        } else {
          return -first.msgTime!.compareTo(second.msgTime!);
        }
      });

      // 建立索引
      spaceMessageItemMap[messageGroup.id] = {};
      for (MessageItemResp messageItem in chats) {
        spaceMessageItemMap[messageGroup.id]![messageItem.id] = messageItem;
      }
    }
    orgChatCache.chats = spaces;
  }

  String _msgPreHandler(MessageDetailResp detail, TargetResp userInfo) {
    // 空间转换
    if (detail.spaceId == null || detail.spaceId == detail.fromId) {
      detail.spaceId = userInfo.id;
    }

    // 确定空间
    if (!spaceMap.containsKey(detail.spaceId)) {
      throw Exception("不存在空间${detail.spaceId}");
    }

    var sessionId = detail.toId;

    // 匹配群
    SpaceMessagesResp space = spaceMap[detail.spaceId]!;
    for (var chat in space.chats) {
      if (chat.typeName == "人员" &&
          detail.fromId == chat.id &&
          detail.toId == userInfo.id) {
        sessionId = detail.fromId;
      }
    }

    return sessionId;
  }

  /// 接受消息
  Future<void> onReceiveMessage(List<dynamic> messageList) async {
    if (messageList.isEmpty) {
      return;
    }
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);

    for (var message in messageList) {
      log.info("接收到一条新的消息$message");
      var detail = MessageDetailResp.fromMap(message);

      try {
        // 会话 ID
        String sessionId = _msgPreHandler(detail, userInfo);

        // 对象
        MessageItemResp? item = spaceMessageItemMap[detail.spaceId]?[sessionId];
        if (item == null) {
          throw Exception("不存在会话对象$sessionId");
        }

        if (detail.spaceId == userInfo.id) {
          // 如果是个人空间，存储一下信息
          await HubUtil().cacheMsg(sessionId, detail);
        }
        String? msgBody = detail.msgBody;
        item.msgBody = msgBody;
        item.msgTime = detail.createTime;
        item.msgType = detail.msgType;
        if (item.msgType == "recall") {
          bool hasPic = msgBody?.contains("<img>") ?? false;
          item.showTxt = hasPic ? "[图片]" : msgBody;
        } else {
          item.showTxt = msgBody;
        }
        if (item.typeName != "人员") {
          String name = orgChatCache.nameMap[detail.fromId];
          item.showTxt = "$name：${item.showTxt}";
        }

        bool isTalking = false;
        if (Get.isRegistered<ChatController>()) {
          ChatController chatController = Get.find();
          isTalking =
              chatController.onReceiveMsg(detail.spaceId!, sessionId, detail);
        }
        if (!isTalking && detail.fromId != userInfo.id) {
          // 不在会话中且不是我发的消息
          item.noRead = (item.noRead ?? 0) + 1;
        }

        orgChatCache.messageDetail = detail;
        orgChatCache.target = item;

        // 更新试图
        update();

        // 如果正在后台，发送本地消息提示
        _pushMessage(item, detail);

        // 缓存会话
        HubUtil().cacheChats(orgChatCache);
      } catch (error) {
        log.info("接收消息异常:$error");
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    currentAppState = state;
  }

  void _pushMessage(MessageItemResp item, MessageDetailResp detail) {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    if (currentAppState != null &&
        currentAppState == AppLifecycleState.paused &&
        detail.fromId != userInfo.id) {
      // 当前系统在后台，且不是自己发的消息
      var android = const AndroidNotificationDetails(
          'NewMessageNotification', '新消息通知',
          priority: Priority.max, importance: Importance.max);
      var notificationDetails = NotificationDetails(android: android);
      FlutterLocalNotificationsPlugin()
          .show(0, item.name, item.showTxt, notificationDetails);
    }
  }
}
