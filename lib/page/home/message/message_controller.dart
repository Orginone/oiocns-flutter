import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/component/tab_combine.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/logic/server/chat_server.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';
import 'package:orginone/page/home/message/message_page.dart';
import 'package:orginone/page/home/message/message_setting/message_setting_controller.dart';
import 'package:orginone/logic/server/store_server.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/notification_util.dart';
import 'package:orginone/util/string_util.dart';

import 'chat/chat_controller.dart';

class MessageController extends GetxController
    with WidgetsBindingObserver, GetSingleTickerProviderStateMixin {
  // 日志对象
  Logger log = Logger("MessageController");

  // 参数
  OrgChatCache orgChatCache = OrgChatCache.empty();

  // 会话索引
  Map<String, SpaceMessagesResp> spaceMap = {};
  Map<String, Map<String, MessageItemResp>> spaceMessageItemMap = {};

  // 当前 app 状态
  AppLifecycleState? currentAppState;

  // 应用内 Tab
  late TabController tabController;
  late TabCombine recentChat, mailList;
  late List<TabCombine> tabs;

  // 会话加载状态
  bool isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    initTabs();
    // 监听页面的生命周期
    WidgetsBinding.instance.addObserver(this);
    // 订阅聊天面板信息
    _subscribingCharts();
  }

  initTabs() {
    recentChat = TabCombine(
      tabView: const RecentChat(),
      breadCrumbItem: chatRecentPoint,
      body: _chatTab("会话"),
    );
    mailList = TabCombine(
      tabView: const Relation(),
      breadCrumbItem: chatMailPoint,
      body: Text("通讯录", style: AFont.instance.size22Black3),
    );
    tabs = [recentChat, mailList];
    tabController = TabController(length: tabs.length, vsync: this);
    int preIndex = tabController.index;
    tabController.addListener(() {
      if (preIndex == tabController.index) {
        return;
      }
      if (Get.isRegistered<HomeController>()) {
        var homeController = Get.find<HomeController>();
        var bcController = homeController.breadCrumbController;
        bcController.redirect(tabs[tabController.index].breadCrumbItem!);
      }
      preIndex = tabController.index;
    });
  }

  Widget _chatTab(String name) {
    return SizedBox(
      child: Stack(children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            name,
            style: AFont.instance.size22Black3,
          ),
        ),
        GetBuilder<MessageController>(builder: (controller) => _noRead)
      ]),
    );
  }

  get _noRead => Align(
      alignment: Alignment.topRight,
      child: hasNoRead()
          ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
          : Container());

  /// 获取消息会话对象
  MessageItemResp getMsgItem(String spaceId, String messageItemId) {
    return spaceMessageItemMap[spaceId]![messageItemId]!;
  }

  /// 分组排序
  sortingGroups() {
    List<SpaceMessagesResp> groups = orgChatCache.chats;
    List<SpaceMessagesResp> spaces = [];
    SpaceMessagesResp? topping;
    for (SpaceMessagesResp space in groups) {
      var isCurrent = space.id == auth.spaceId;
      if (space.id == "topping") {
        topping = space;
        space.isExpand = true;
      } else if (isCurrent) {
        space.isExpand = isCurrent;
        spaces.insert(0, space);
      } else {
        space.isExpand = false;
        spaces.add(space);
      }
    }
    if (topping != null) {
      spaces.insert(0, topping);
    }
    orgChatCache.chats = spaces;
  }

  /// 组内会话排序
  sortingItems(List<MessageItemResp> chats) {
    // 会话
    chats.sort((first, second) {
      if (first.msgTime == null || second.msgTime == null) {
        return 0;
      } else {
        return -first.msgTime!.compareTo(second.msgTime!);
      }
    });
    // 置顶排序
    chats.sort((first, second) {
      first.isTop ??= false;
      second.isTop ??= false;
      if (first.isTop == second.isTop) {
        return first.isTop! ? -1 : 0;
      } else {
        return first.isTop! ? -1 : 1;
      }
    });
  }

  /// 刷新会话
  Future<dynamic> refreshCharts() async {
    if (isLoaded) {
      // 只有从缓存拿过会话了才能刷新会话

      // 读取聊天群
      List<SpaceMessagesResp> messageGroups = await chatServer.getChats();

      // 处理空间并排序
      orgChatCache.chats = _spaceHandling(messageGroups);
      sortingGroups();
      update();

      // 缓存消息
      await storeServer.cacheChats(orgChatCache);
    }
  }

  /// 订阅聊天群变动
  _subscribingCharts() async {
    SubscriptionKey key = SubscriptionKey.orgChat;
    String domain = Domain.user.name;
    await storeServer.subscribing(key, domain, _updateChats);
    if (orgChatCache.chats.isEmpty) {
      ApiResp apiResp = await storeServer.get(key.name, domain);
      _updateChats(apiResp.data);
    }
  }

  /// 从订阅通道拿到的数据直接更新试图
  _updateChats(Map<String, dynamic> data) {
    orgChatCache = OrgChatCache(data);
    orgChatCache.chats = _spaceHandling(orgChatCache.chats);
    sortingGroups();
    _latestMsgHandling(orgChatCache.messageDetail);
    update();

    // 表示从缓存会话已经加载完毕
    isLoaded = true;
  }

  /// 最新的消息处理
  _latestMsgHandling(MessageDetailResp? detail) {
    if (detail == null) {
      return;
    }
    if (Get.isRegistered<ChatController>()) {
      // 消息预处理
      TargetResp userInfo = auth.userInfo;
      var sessionId = detail.toId;
      if (detail.toId == userInfo.id) {
        sessionId = detail.fromId;
      }

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

    // 置顶会话
    groups = groups.where((item) => item.id != "topping").toList();
    SpaceMessagesResp topGroup = SpaceMessagesResp("topping", "置顶会话", []);

    bool hasTop = false;
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
            messageItem.msgType ??= oldItem.msgType;
            messageItem.msgBody ??= oldItem.msgBody;
            messageItem.personNum ??= oldItem.personNum;
            messageItem.noRead ??= oldItem.noRead;
            messageItem.showTxt ??= oldItem.showTxt;
            messageItem.isTop ??= oldItem.isTop;
          }
        }
        newSpaceMessageItemMap[spaceId]![id] = messageItem;
        if (messageItem.isTop == true) {
          hasTop = true;
        }
      }

      // 组内排序
      sortingItems(group.chats);
      spaces.add(group);
    }
    if (hasTop) {
      spaces.insert(0, topGroup);
    }
    spaceMap = newSpaceMap;
    spaceMessageItemMap = newSpaceMessageItemMap;
    return spaces;
  }

  /// 接受消息
  Future<void> onReceiveMessage(List<dynamic> messageList) async {
    if (messageList.isEmpty) {
      return;
    }
    for (var message in messageList) {
      log.info("接收到一条新的消息$message");
      var detail = MessageDetailResp.fromMap(message);

      try {
        // 会话 ID
        var sessionId = detail.toId;
        if (detail.toId == auth.userId) {
          sessionId = detail.fromId;
        }

        // 确定会话
        MessageItemResp? currentItem;
        outer:
        for (var space in orgChatCache.chats) {
          for (var item in space.chats) {
            if (item.id == sessionId) {
              currentItem = item;
            }
            if (item.typeName == TargetType.person.name &&
                currentItem != null &&
                detail.spaceId != item.spaceId) {
              currentItem = null;
            }
            if (currentItem != null) {
              break outer;
            }
          }
        }
        if (currentItem == null) {
          throw Exception("未找到会话!");
        }

        if (detail.msgType == MsgType.topping.name) {
          currentItem.isTop = bool.fromEnvironment(detail.msgBody ?? "false");
        } else {
          if (detail.spaceId == auth.userId) {
            // 如果是个人空间，存储一下信息
            await storeServer.cacheMsg(sessionId, detail);
          }

          // 处理消息
          detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
          String? msgBody = detail.msgBody;
          currentItem.msgBody = msgBody;
          currentItem.msgTime = detail.createTime;
          currentItem.msgType = detail.msgType;
          if (currentItem.msgType == MsgType.recall.name) {
            currentItem.showTxt = StringUtil.getRecallBody(currentItem, detail);
          } else if (currentItem.msgType == MsgType.voice.name) {
            currentItem.showTxt = "[语音]";
          } else if (currentItem.msgType == MsgType.image.name) {
            currentItem.showTxt = "[图片]";
          } else if (currentItem.msgType == MsgType.pull.name) {
            var msg = jsonDecode(msgBody!);
            var passive = msg["passive"] as List<dynamic>;
            currentItem.showTxt = msg["remark"];
            if (currentItem.personNum != null) {
              currentItem.personNum = currentItem.personNum! + passive.length;
            }
          } else if (currentItem.msgType == MsgType.createCohort.name) {
            currentItem.personNum = 1;
            currentItem.showTxt = msgBody;
          } else if (currentItem.msgType == MsgType.exitCohort.name) {
            currentItem.personNum = currentItem.personNum! - 1;
            currentItem.showTxt = msgBody;
          } else {
            currentItem.showTxt = msgBody;
          }
          if (currentItem.typeName != TargetType.person.name &&
              currentItem.msgType != MsgType.pull.name &&
              currentItem.msgType != MsgType.createCohort.name &&
              currentItem.msgType != MsgType.exitCohort.name) {
            var nameMap = orgChatCache.nameMap;
            if (!nameMap.containsKey(detail.fromId)) {
              nameMap[detail.fromId] = await chatServer.getName(detail.fromId);
            }
            String name = nameMap[detail.fromId];
            currentItem.showTxt = "$name: ${currentItem.showTxt}";
          }

          bool isTalking = false;
          for (MessageItemResp openItem in orgChatCache.openChats) {
            if (openItem.id == currentItem.id &&
                openItem.spaceId == currentItem.spaceId) {
              isTalking = true;
            }
          }
          if (detail.fromId != auth.userId ||
              currentItem.msgType != MsgType.pull.name) {
            // 如果不是我发的消息
            if (detail.msgType == MsgType.recall.name) {
              // 撤回消息需要减 1
              int noRead = currentItem.noRead ?? 0;
              if (noRead > 0) currentItem.noRead = noRead - 1;
            } else if (!isTalking) {
              // 不在会话中需要加 1
              int noRead = currentItem.noRead ?? 0;
              currentItem.noRead = noRead + 1;
            }

            // 如果正在后台，发送本地消息提示
            if (currentAppState == AppLifecycleState.paused) {
              var name = currentItem.name;
              var txt = currentItem.showTxt ?? "";
              NotificationUtil.showNewMsg(name, txt);
            }
          }

          // 最新的消息
          orgChatCache.messageDetail = detail;
          orgChatCache.target = currentItem;
          for (var group in orgChatCache.chats) {
            sortingItems(group.chats);
          }

          // 近期会话不存在就加入
          orgChatCache.recentChats ??= [];
          orgChatCache.recentChats = orgChatCache.recentChats!
              .where((item) =>
                  item.id != currentItem!.id ||
                  item.spaceId != currentItem.spaceId)
              .toList();

          if (detail.msgType != MsgType.deleteCohort.name) {
            // 如果是解散了群聊, 就不加入了
            if (detail.msgType == MsgType.exitCohort.name) {
              // 如果是自己退出了群聊, 就不加入了
              if (detail.fromId != auth.userId) {
                orgChatCache.recentChats!.add(currentItem);
              }
            } else {
              orgChatCache.recentChats!.add(currentItem);
            }
          }
          sortingItems(orgChatCache.recentChats!);

          // 如果当前会话正打开
          if (Get.isRegistered<ChatController>()) {
            ChatController chatController = Get.find();
            chatController.onReceiveMsg(detail.spaceId!, sessionId, detail);
          }

          // 如果设置页面正打开中
          if (Get.isRegistered<MessageSettingController>()) {
            var settingController = Get.find<MessageSettingController>();
            settingController.morePersons();
          }
        }

        // 更新试图
        update();

        // 缓存会话
        await storeServer.cacheChats(orgChatCache);
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

  chatEventFire(ChatFunc func, String spaceId, MessageItemResp item) async {
    switch (func) {
      case ChatFunc.topping:
      case ChatFunc.cancelTopping:
        item.isTop = func == ChatFunc.topping;
        orgChatCache.chats = _spaceHandling(orgChatCache.chats);
        sortingGroups();
        sortingItems(orgChatCache.recentChats ?? []);
        await storeServer.cacheChats(orgChatCache);
        update();
        break;
      case ChatFunc.remove:
        orgChatCache.recentChats?.remove(item);
        await storeServer.cacheChats(orgChatCache);
        update();
        break;
    }
  }

  bool hasNoRead() {
    var has = orgChatCache.recentChats?.firstWhereOrNull(
        (item) => (item.noRead ?? 0) > 0 && !(item.isInterruption ?? false));
    return has != null;
  }
}
