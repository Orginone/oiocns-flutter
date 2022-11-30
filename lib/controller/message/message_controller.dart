import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/bucket_api.dart';
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
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/core/ui/message/message_item_widget.dart';
import 'package:orginone/enumeration/enum_map.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/chat/chat_impl.dart';
import 'package:orginone/core/chat/i_chat.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/message/message_page.dart';
import 'package:orginone/util/encryption_util.dart';

class Detail {
  final MessageDetail resp;

  const Detail.fromResp(this.resp);

  /// 构造工厂
  factory Detail(MessageDetail resp) {
    MsgType msgType = EnumMap.messageTypeMap[resp.msgType] ?? MsgType.unknown;
    Map<String, dynamic> msgMap = jsonDecode(resp.msgBody ?? "{}");
    switch (msgType) {
      case MsgType.file:
        // 文件
        String fileName = msgMap["fileName"] ?? "";
        String path = msgMap["path"] ?? "";
        String size = msgMap["size"] ?? "";
        return FileDetail(
          fileName: fileName,
          resp: resp,
          status: FileStatus.local.obs,
          progress: 0.0.obs,
          path: path,
          size: size,
        );
      case MsgType.voice:
        // 语音
        int milliseconds = msgMap["milliseconds"] ?? 0;
        List<dynamic> rowBytes = msgMap["bytes"] ?? [];
        List<int> tempBytes = rowBytes.map((byte) => byte as int).toList();
        return VoiceDetail(
          resp: resp,
          status: VoiceStatus.stop.obs,
          initProgress: milliseconds,
          progress: milliseconds.obs,
          bytes: Uint8List.fromList(tempBytes),
        );
      default:
        return Detail.fromResp(resp);
    }
  }
}

/// 播放状态
enum VoiceStatus { stop, playing }

/// 语音播放类
class VoiceDetail extends Detail {
  final Rx<VoiceStatus> status;
  final int initProgress;
  final RxInt progress;
  final Uint8List bytes;

  const VoiceDetail({
    required MessageDetail resp,
    required this.status,
    required this.initProgress,
    required this.progress,
    required this.bytes,
  }) : super.fromResp(resp);
}

/// 文件状态
enum FileStatus { local, uploading, pausing, stopping, uploaded, synced }

/// 文件上传状态类
class FileDetail extends Detail {
  final String fileName;
  final Rx<FileStatus> status;
  final RxDouble progress;
  final String path;
  final String size;

  const FileDetail({
    required MessageDetail resp,
    required this.fileName,
    required this.status,
    required this.progress,
    required this.path,
    required this.size,
  }) : super.fromResp(resp);
}

enum ReceiveEvent {
  receiveMessage("RecvMsg"),
  chatRefresh("ChatRefresh");

  final String keyWord;

  const ReceiveEvent(this.keyWord);
}

class MessageController extends BaseController<IChatGroup>
    with WidgetsBindingObserver, GetTickerProviderStateMixin {
  // 日志对象
  Logger log = Logger("MessageController");

  final RxList<IChat> _chats = <IChat>[].obs;
  final Rx<IChat?> _currentChat = Rxn();
  final Rx<IChat?> _currentSetting = Rxn();
  Timer? _setNullTimer;

  List<IChat> get chats => _chats;

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

  IChat? get getCurrentChat => _currentChat.value;

  IChat? get getCurrentSetting => _currentSetting.value;

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

  /// 设置顶部
  setGroupTop(String spaceId) {
    var position = indexWhere((item) => item.spaceId == spaceId);
    if (position != -1) {
      var chatGroup = removeAt(position);
      chatGroup.openOrNot(true);
      insert(0, chatGroup);
      for (int i = 1; i < getSize(); i++) {
        get(i).openOrNot(false);
      }
    }
  }

  /// 设置当前会话为空
  setCurrentNull() {
    _setNullTimer = Timer(const Duration(seconds: 1), () {
      _currentChat.value = null;
    });
  }

  /// 设置当前页面
  Future<bool> setCurrentSetting(String spaceId, String chatId) async {
    IChat? chat = ref(spaceId, chatId);
    if (chat != null) {
      _currentSetting.value = chat;
      if (chat.persons.isEmpty) {
        await chat.morePersons();
      }
      return true;
    }
    return false;
  }

  /// 通过会话设置
  Future<bool> setCurrentByChat(IChat chat) async {
    return await setCurrent(chat.spaceId, chat.chatId);
  }

  /// 群组或单位可以只通过 ID 设置
  Future<bool> setCurrentById(String chatId) async {
    IChat? chat = refById(chatId);
    if (chat != null) {
      _setCurrent(chat);
      return true;
    }
    Fluttertoast.showToast(msg: "未获取到会话内容！");
    throw Exception("未获取到会话内容！");
  }

  /// 通过空间 ID，会话 ID设置
  Future<bool> setCurrent(String spaceId, String chatId) async {
    IChat? chat = ref(spaceId, chatId);
    if (chat != null) {
      _setCurrent(chat);
      return true;
    }
    Fluttertoast.showToast(msg: "未获取到会话内容！");
    throw Exception("未获取到会话内容！");
  }

  Future<bool> _setCurrent(IChat chat) async {
    _setNullTimer?.cancel();
    _currentChat.value = chat;
    chat.readAll();
    if (chat.messages.length <= 30) {
      await chat.moreMessage();
    }
    if (chat.persons.isEmpty) {
      await chat.morePersons();
    }
    _appendChat(chat);
    await _cacheChats();
    return true;
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
    await Kernel.getInstance.anyStore.set(key, data, domain);
  }

  /// 加载通讯录
  _loadingMails() async {
    if (getSize() > 0) return;
    addAll(await _getMails());
  }

  /// 获取通讯录
  Future<List<IChatGroup>> _getMails() async {
    var model = ChatsReqModel(
      spaceId: auth.userId,
      cohortName: TargetType.cohort.label,
      spaceTypeName: TargetType.company.label,
    );
    List<ChatGroup> ansGroups = await Kernel.getInstance.queryImChats(model);
    List<IChatGroup> groups = [];
    for (var group in ansGroups) {
      groups.add(BaseChatGroup(
        isOpened: auth.spaceId == group.id,
        spaceId: group.id,
        spaceName: group.name,
        chats: group.chats.map((item) {
          return createChat(group.id, group.name, item);
        }).toList(),
      ));
    }
    return groups;
  }

  /// 刷新通讯录
  refreshMails() async {
    // 加载会话组
    List<IChatGroup> groups = await _getMails();
    clear();
    addAll(groups);

    // 获取最新消息
    var key = SubscriptionKey.userChat;
    var domain = Domain.user.name;
    var ans = await Kernel.getInstance.anyStore.get(key.keyWord, domain);
    _chats.clear();
    _updateMails(ans.data);

    // 当前有在编辑的就刷新一下
    var chat = _currentChat.value;
    var setting = _currentSetting.value;
    if (chat != null) await setCurrent(chat.spaceId, chat.chatId);
    if (setting != null) {
      await setCurrentSetting(setting.spaceId, setting.chatId);
    }
  }

  /// 初始化监听器
  _initListener() async {
    // 消息接受订阅
    var receive = ReceiveEvent.receiveMessage.keyWord;
    var chatRefresh = ReceiveEvent.chatRefresh.keyWord;
    Kernel.getInstance.on(receive, (message) => onReceiveMessage([message]));
    Kernel.getInstance.on(chatRefresh, (message) => refreshMails());

    // 订阅最新的消息会话
    var key = SubscriptionKey.userChat;
    var domain = Domain.user.name;
    Kernel.getInstance.anyStore.subscribing(key, domain, _updateMails);
  }

  /// 获取会话的位置
  _getPositioned(String spaceId, String chatId) {
    return _chats.indexWhere((item) {
      return item.spaceId == spaceId && item.chatId == chatId;
    });
  }

  /// 删除好友
  Future<void> exitCurrentTarget() async {
    var chat = getCurrentSetting;
    if (chat != null) {
      if (Get.isRegistered<TargetController>()) {
        var targetCtrl = Get.find<TargetController>();
        var typeName = chat.target.typeName;
        var cohorts = [TargetType.cohort.label, TargetType.jobCohort.label];
        if (typeName == TargetType.person.label) {
          await targetCtrl.currentPerson.removeFriends([chat.target.id]);
        } else if (cohorts.contains(typeName)) {
          await targetCtrl.currentPerson.exitCohort(chat.target.id);
        }
      }
    }
  }

  /// 不存在会话就加入
  _appendChat(IChat targetChat) {
    var position = _getPositioned(targetChat.spaceId, targetChat.chatId);
    if (position == -1) {
      _chats.insert(0, targetChat);
    } else {
      _chats[position] = targetChat;
    }
  }

  /// 更新视图
  _updateMails(Map<String, dynamic> data) {
    log.info("接收到的通讯录：$data");
    List<dynamic> chats = data["chats"];
    for (Map<String, dynamic>? chat in chats) {
      if (chat == null) {
        continue;
      }
      var spaceId = chat["spaceId"];
      var chatId = chat["chatId"];
      var matchedChat = ref(spaceId, chatId);
      if (matchedChat != null) {
        matchedChat.loadCache(ChatCache.fromMap(chat));
        _appendChat(matchedChat);
      }
    }
  }

  /// 获取存在的会话
  IChat? ref(String spaceId, String chatId) {
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

  /// 通过 ID 获取存在的会话
  IChat? refById(String chatId) {
    IChat? tempChat;
    forEach((chatGroup) {
      for (IChat chat in chatGroup.chats) {
        if (chat.chatId == chatId) {
          tempChat = chat;
          return false;
        }
      }
      return true;
    });
    return tempChat;
  }

  /// 设置置顶
  _setTop(IChat targetChat) {
    var position = _getPositioned(targetChat.spaceId, targetChat.chatId);
    if (position != -1) {
      var chat = _chats.removeAt(position);
      _chats.insert(0, chat);
    }
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
        _noRead,
      ]),
    );
  }

  get _noRead => Align(
      alignment: Alignment.topRight,
      child: Obx(() => hasNoRead()
          ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
          : Container()));

  bool hasNoRead() {
    var has = _chats.firstWhereOrNull((item) => item.noReadCount != 0);
    return has != null;
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
  Future<void> onReceiveMessage(List<dynamic> messages) async {
    if (getSize() == 0) {
      Timer(const Duration(seconds: 1), () => onReceiveMessage(messages));
      return;
    }

    for (var item in messages) {
      var message = MessageDetail.fromMap(item);

      // 会话 ID
      var sessionId = message.toId;
      if (message.toId == auth.userId) {
        sessionId = message.fromId;
      }

      super.forEach((chatGroup) {
        for (var chat in chatGroup.chats) {
          bool isMatched = chat.chatId == sessionId;
          if (isMatched && chat.target.typeName == TargetType.person.label) {
            isMatched = message.spaceId == chat.spaceId;
          }
          if (!isMatched) continue;
          chat.receiveMessage(message, _currentChat.value != chat);
          _appendChat(chat);
          _setTop(chat);
          _cacheChats();
          return false;
        }
        return true;
      });
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
        await Kernel.getInstance.anyStore.cacheChats(orgChatCache);
        update();
        break;
      case ChatFunc.remove:
        orgChatCache.recentChats?.remove(item);
        await Kernel.getInstance.anyStore.cacheChats(orgChatCache);
        update();
        break;
    }
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
    await currentChat.sendMsg(
      msgType: MsgType.voice,
      msgBody: jsonEncode(msgBody),
    );
  }

  /// 相册选择照片后回调
  void imagePicked(XFile file) async {
    Image imageCompo = Image.memory(await file.readAsBytes());
    imageCompo.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (imageInfo, synchronousCall) async {
          String encodedPrefix = EncryptionUtil.encodeURLString("");

          var filePath = file.path;
          var fileName = file.name;

          await BucketApi.uploadChunk(
            prefix: encodedPrefix,
            filePath: filePath,
            fileName: fileName,
          );

          Map<String, dynamic> body = {
            "width": imageInfo.image.width,
            "height": imageInfo.image.height,
            "path": fileName,
          };

          var current = _currentChat.value;
          await current?.sendMsg(
            msgBody: jsonEncode(body),
            msgType: MsgType.image,
          );
        },
      ),
    );
  }

  /// 语音录制完成并发送
  void filePicked(String fileName, String filePath) async {
    // TargetResp userInfo = auth.userInfo;
    // String prefix = "chat_${userInfo.id}_${messageItem.id}_voice";
    // log.info("====> prefix:$prefix");
    // String encodedPrefix = EncryptionUtil.encodeURLString(prefix);
    //
    // try {
    //   await BucketApi.create(prefix: encodedPrefix);
    // } catch (error) {
    //   log.warning("====> 创建目录失败：$error");
    // }
    // await BucketApi.upload(
    //   prefix: encodedPrefix,
    //   filePath: filePath,
    //   fileName: fileName,
    // );
    //
    // Map<String, dynamic> msgBody = {
    //   "path": "$prefix/$fileName",
    // };
    // sendOneMessage(jsonEncode(msgBody), msgType: MsgType.voice);
  }
}

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}
