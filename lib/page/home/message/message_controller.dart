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

  // 分组排序
  sortingGroups() {
    HomeController homeController = Get.find<HomeController>();
    List<SpaceMessagesResp> groups = orgChatCache.chats;
    List<SpaceMessagesResp> spaces = [];
    for (SpaceMessagesResp space in groups) {
      if (space.id == homeController.currentSpace.id) {
        space.isExpand = true;
        spaces.insert(0, space);
      } else {
        spaces.add(space);
      }
    }
    orgChatCache.chats = spaces;
  }

  // 组内会话排序
  sortingItems(SpaceMessagesResp spaceMessagesResp) {
    // 会话
    spaceMessagesResp.chats.sort((first, second) {
      if (first.msgTime == null || second.msgTime == null) {
        return 0;
      } else {
        return -first.msgTime!.compareTo(second.msgTime!);
      }
    });
  }

  Future<dynamic> refreshCharts() async {
    // 读取聊天群
    List<SpaceMessagesResp> messageGroups = await HubUtil().getChats();

    // 处理空间并排序
    orgChatCache.chats = _spaceHandling(messageGroups);
    sortingGroups();
    update();

    // 缓存消息
    await HubUtil().cacheChats(orgChatCache);
  }

  /// 订阅聊天群变动
  _subscribingCharts() async {
    SubscriptionKey key = SubscriptionKey.orgChat;
    String domain = Domain.user.name;
    await AnyStoreUtil().subscribing(key, domain, _updateChats);
    if (orgChatCache.chats.isEmpty) {
      await refreshCharts();
    }
  }

  /// 从订阅通道拿到的数据直接更新试图
  _updateChats(Map<String, dynamic> data) {
    orgChatCache = OrgChatCache(data);
    orgChatCache.chats = _spaceHandling(orgChatCache.chats);
    sortingGroups();
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
  List<SpaceMessagesResp> _spaceHandling(List<SpaceMessagesResp> groups) {
    // 新的数组
    List<SpaceMessagesResp> spaces = [];
    Map<String, SpaceMessagesResp> newSpaceMap = {};
    Map<String, Map<String, MessageItemResp>> newSpaceMessageItemMap = {};

    for (var group in groups) {
      // 初始数据
      String spaceId = group.id;
      List<MessageItemResp> chats = group.chats;

      // 建立索引
      newSpaceMap[spaceId] = group;
      newSpaceMessageItemMap[spaceId] = {};

      // 数据映射
      for (MessageItemResp messageItem in chats) {
        var id = messageItem.id;
        if (spaceMessageItemMap.containsKey(spaceId)) {
          var messageItemMap = spaceMessageItemMap[spaceId]!;
          if (messageItemMap.containsKey(id)) {
            var oldItem = messageItemMap[id]!;
            messageItem.msgTime = oldItem.msgTime;
            messageItem.msgType = oldItem.msgType;
            messageItem.msgBody = oldItem.msgBody;
            messageItem.personNum = oldItem.personNum;
            messageItem.noRead = oldItem.noRead;
            messageItem.showTxt = oldItem.showTxt;
          }
        }
        newSpaceMessageItemMap[spaceId]![id] = messageItem;
      }

      // 组内排序
      sortingItems(group);
      spaces.add(group);
    }
    spaceMap = newSpaceMap;
    spaceMessageItemMap = newSpaceMessageItemMap;
    return spaces;
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

        if (Get.isRegistered<ChatController>()) {
          ChatController chatController = Get.find();
          chatController.onReceiveMsg(detail.spaceId!, sessionId, detail);
        }
        bool isTalking = false;
        for (MessageItemResp openItem in orgChatCache.openChats) {
          if (openItem.id == item.id && openItem.spaceId == item.spaceId) {
            isTalking = true;
          }
        }
        if (!isTalking && detail.fromId != userInfo.id) {
          // 如果正在后台，发送本地消息提示
          _pushMessage(item, detail);
          // 不在会话中且不是我发的消息
          item.noRead = (item.noRead ?? 0) + 1;
        }

        orgChatCache.messageDetail = detail;
        orgChatCache.target = item;
        for (var group in orgChatCache.chats) {
          sortingItems(group);
        }

        // 更新试图
        update();

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
