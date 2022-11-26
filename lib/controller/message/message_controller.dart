import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/hub/any_store.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/component/tab_combine.dart';
import 'package:orginone/controller/base_controller.dart';
import 'package:orginone/core/ui/message/message_item_widget.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/api/hub/chat_server.dart';
import 'package:orginone/core/chat/chat_impl.dart';
import 'package:orginone/core/chat/i_chat.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/message/message_page.dart';
import 'package:orginone/page/home/message/message_setting/message_setting_controller.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/notification_util.dart';
import 'package:orginone/util/string_util.dart';

import '../../page/home/message/chat/chat_controller.dart';

enum ReceiveEvent {
  receiveMessage("RecvMsg");

  final String keyWord;

  const ReceiveEvent(this.keyWord);
}

class MessageController extends BaseController<IChatGroup>
    with WidgetsBindingObserver, GetSingleTickerProviderStateMixin {
  // 日志对象
  Logger log = Logger("MessageController");

  final RxList<IChat> _chats = <IChat>[].obs;
  final Rx<IChat?> _currentChat = Rxn();

  // 参数
  OrgChatCache orgChatCache = OrgChatCache.empty();

  // 会话索引
  Map<String, ChatGroup> spaceMap = {};
  Map<String, Map<String, MessageTarget>> spaceMessageItemMap = {};

  // 当前 app 状态
  AppLifecycleState? currentAppState;

  // 应用内 Tab
  late TabController tabController;
  late TabCombine recentChat, mailList;
  late List<TabCombine> tabs;

  // 会话加载状态
  bool isLoaded = false;

  var messageScrollController = ScrollController();

  // 语音相关
  FlutterSoundPlayer? _soundPlayer;
  StreamSubscription? _mt;
  AnimationController? animationController;
  Animation<AlignmentGeometry>? animation;
  Map<String, VoiceDetail> playStatusMap = {};
  VoiceDetail? _currentVoicePlay;

  @override
  void onInit() async {
    super.onInit();
    // 监听页面的生命周期
    WidgetsBinding.instance.addObserver(this);
    // 初始化 Tabs
    initTabs();
    // 获取通讯录
    await _loadingMails();
    // 订阅最新会话
    await _initListener();
  }

  int getChatSize() {
    return _chats.length;
  }

  Widget getChatWidget(int index) {
    return _chats[index].mapping();
  }

  IChat get getCurrentChat => _currentChat.value!;

  /// 获取名称
  String getName(String id) {
    String name = "未知";
    forEach((chatGroup) {
      for (var chat in chatGroup.chats) {
        if (chat.target.id == id) {
          name = chat.target.name;
          return false;
        }
      }
      return true;
    });
    return name;
  }

  /// 设置当前会话
  setCurrent(String spaceId, String chatId) async {
    IChat? chat = _ref(spaceId, chatId);
    if (chat != null) {
      _currentChat.value = chat;
      chat.readAll();
      if (chat.messages.isEmpty) {
        await chat.moreMessage();
      }
      if (chat.persons.isEmpty) {
        await chat.morePersons();
      }
      _appendChat(chat);
      await _cacheChats();
    }
  }

  /// 缓存当前会话
  _cacheChats() async {
    var key = SubscriptionKey.userChat.keyWord;
    var domain = Domain.user.name;
    var chats = _chats.map((c) => c.getCache()).toList().reversed.toList();
    var data = {
      "operation": "replaceAll",
      "data": {"chats": chats}
    };
    await kernelApi.anyStore.set(key, data, domain);
  }

  /// 加载通讯录
  _loadingMails() async {
    List<ChatGroup> ansGroups = await kernelApi.queryImChats(ChatsReqModel(
      spaceId: auth.userId,
      cohortName: TargetType.cohort.label,
      spaceTypeName: TargetType.company.label,
    ));
    for (var group in ansGroups) {
      var iChatGroup = BaseChatGroup(
        isOpened: auth.spaceId == group.id,
        spaceId: group.id,
        spaceName: group.name,
        chats: group.chats.map((item) {
          return createChat(group.id, group.name, item);
        }).toList(),
      );
      add(iChatGroup);
    }
  }

  /// 初始化监听器
  _initListener() async {
    // 消息接受订阅
    var ketWord = ReceiveEvent.receiveMessage.keyWord;
    kernelApi.on(ketWord, (message) => onReceiveMessage([message]));

    // 订阅最新的消息会话
    var key = SubscriptionKey.userChat;
    var domain = Domain.user.name;
    kernelApi.anyStore.subscribing(key, domain, _updateChats);
  }

  _appendChat(IChat targetChat) {
    var matchedChat = _chats.indexWhere((item) {
      return item.spaceId == targetChat.spaceId &&
          item.chatId == targetChat.chatId;
    });
    if (matchedChat != -1) {
      _chats[matchedChat] = targetChat;
    } else {
      _chats.insert(0, targetChat);
    }
  }

  /// 更新视图
  _updateChats(Map<String, dynamic> data) async {
    List<dynamic> chats = data["chats"];
    for (Map<String, dynamic>? chat in chats) {
      if (chat == null) {
        continue;
      }
      var spaceId = chat["spaceId"];
      var chatId = chat["chatId"];
      var matchedChat = _ref(spaceId, chatId);
      if (matchedChat != null) {
        matchedChat.loadCache(ChatCache.fromMap(chat));
        _appendChat(matchedChat);
      }
    }
  }

  /// 获取存在的会话
  IChat? _ref(String spaceId, String chatId) {
    IChat? tempChat;
    forEach((chatGroup) {
      if (chatGroup.spaceId == spaceId) {
        for (IChat chat in chatGroup.chats) {
          if (chat.chatId == chatId) {
            tempChat = chat;
            return false;
          }
        }
      }
      return true;
    });
    return tempChat;
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
  MessageTarget getMsgItem(String spaceId, String messageItemId) {
    return spaceMessageItemMap[spaceId]![messageItemId]!;
  }

  /// 分组排序
  sortingGroups() {
    List<ChatGroup> groups = orgChatCache.chats;
    List<ChatGroup> spaces = [];
    ChatGroup? topping;
    for (ChatGroup space in groups) {
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
  sortingItems(List<MessageTarget> chats) {
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
      List<ChatGroup> messageGroups = await chatServer.getChats();

      // 处理空间并排序
      orgChatCache.chats = _spaceHandling(messageGroups);
      sortingGroups();
      update();

      // 缓存消息
      await kernelApi.anyStore.cacheChats(orgChatCache);
    }
  }

  /// 最新的消息处理
  _latestMsgHandling(MessageDetail? detail) {
    if (detail == null) {
      return;
    }
    if (Get.isRegistered<ChatController>()) {
      // 消息预处理
      Target userInfo = auth.userInfo;
      var sessionId = detail.toId;
      if (detail.toId == userInfo.id) {
        sessionId = detail.fromId;
      }

      ChatController chatController = Get.find<ChatController>();
      chatController.onReceiveMsg(detail.spaceId!, sessionId, detail);
    }
  }

  /// 空间处理
  List<ChatGroup> _spaceHandling(List<ChatGroup> groups) {
    // 新的数组
    List<ChatGroup> spaces = [];
    Map<String, ChatGroup> newSpaceMap = {};
    Map<String, Map<String, MessageTarget>> newSpaceMessageItemMap = {};

    // 置顶会话
    groups = groups.where((item) => item.id != "topping").toList();
    ChatGroup topGroup = ChatGroup("topping", "置顶会话", []);

    bool hasTop = false;
    for (var group in groups) {
      // 初始数据
      String spaceId = group.id;
      List<MessageTarget> chats = group.chats;

      // 建立索引
      newSpaceMap[spaceId] = group;
      newSpaceMessageItemMap[spaceId] = {};

      // 数据映射
      for (MessageTarget messageItem in chats) {
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
      var detail = MessageDetail.fromMap(message);

      try {
        // 会话 ID
        var sessionId = detail.toId;
        if (detail.toId == auth.userId) {
          sessionId = detail.fromId;
        }

        // 确定会话
        MessageTarget? currentItem;
        outer:
        for (var space in orgChatCache.chats) {
          for (var item in space.chats) {
            if (item.id == sessionId) {
              currentItem = item;
            }
            if (item.typeName == TargetType.person.label &&
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
            await kernelApi.anyStore.cacheMsg(sessionId, detail);
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
          if (currentItem.typeName != TargetType.person.label &&
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
          for (MessageTarget openItem in orgChatCache.openChats) {
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
        await kernelApi.anyStore.cacheChats(orgChatCache);
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

  chatEventFire(ChatFunc func, String spaceId, MessageTarget item) async {
    switch (func) {
      case ChatFunc.topping:
      case ChatFunc.cancelTopping:
        item.isTop = func == ChatFunc.topping;
        orgChatCache.chats = _spaceHandling(orgChatCache.chats);
        sortingGroups();
        sortingItems(orgChatCache.recentChats ?? []);
        await kernelApi.anyStore.cacheChats(orgChatCache);
        update();
        break;
      case ChatFunc.remove:
        orgChatCache.recentChats?.remove(item);
        await kernelApi.anyStore.cacheChats(orgChatCache);
        update();
        break;
    }
  }

  bool hasNoRead() {
    var has = _chats.firstWhereOrNull((item) => item.noReadCount != 0);
    return has != null;
  }

  /// 开始播放
  startPlayVoice(String id, Uint8List bytes) async {
    await stopPrePlayVoice();

    // 动画效果
    _currentVoicePlay = playStatusMap[id];
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _currentVoicePlay!.initProgress),
    );
    animation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.linear,
    ));
    animationController!.forward();

    // 监听进度
    _soundPlayer ??= await FlutterSoundPlayer().openPlayer();
    _soundPlayer!.setSubscriptionDuration(const Duration(milliseconds: 50));
    _mt = _soundPlayer!.onProgress!.listen((event) {
      _currentVoicePlay!.progress.value = event.position.inMilliseconds;
    });
    _soundPlayer!
        .startPlayer(
          fromDataBuffer: bytes,
          whenFinished: () => stopPrePlayVoice(),
        )
        .catchError((error) => stopPrePlayVoice());

    // 重新开始播放
    _currentVoicePlay!.status.value = VoiceStatus.playing;
  }

  /// 停止播放
  stopPrePlayVoice() async {
    if (_currentVoicePlay != null) {
      // 改状态
      _currentVoicePlay!.status.value = VoiceStatus.stop;
      _currentVoicePlay!.progress.value = _currentVoicePlay!.initProgress;

      // 关闭播放
      await _soundPlayer?.stopPlayer();
      _mt?.cancel();
      _mt = null;
      _soundPlayer = null;

      // 关闭动画
      animation = null;
      animationController?.stop();
      animationController?.dispose();
      animationController = null;

      // 空引用
      _currentVoicePlay = null;
    }
  }

  /// 语音录制完成并发送
  void sendVoice(String filePath, int milliseconds) async {
    var file = File(filePath);
    Map<String, dynamic> msgBody = {
      "milliseconds": milliseconds,
      "bytes": file.readAsBytesSync()
    };
    IChat currentChat = _currentChat.value!;
    await chatServer.send(
      spaceId: currentChat.spaceId,
      itemId: currentChat.chatId,
      msgBody: jsonEncode(msgBody),
      msgType: MsgType.voice,
    );
  }
}

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}
