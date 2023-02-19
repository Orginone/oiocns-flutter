import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/index.dart';
import 'package:orginone/dart/core/chat/chat.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/util/logger.dart';

class ChatController extends GetxController {
  String _userId = "";
  String _userName = "";
  final RxList<IChatGroup> _groups = <IChatGroup>[].obs;
  final RxList<IChat> _chats = <IChat>[].obs;
  final Rx<IChat?> _curChat = Rxn();
  StreamSubscription<SignIn>? _signInSub;
  StreamSubscription<SignOut>? _signOutSub;

  List<IChatGroup> get groups => _groups;

  List<IChat> get chats => _chats;

  IChat? get chat => _curChat.value;

  String get userId => _userId;

  String get userName => _userName;

  @override
  void onInit() async {
    super.onInit();
    _signInSub = XEventBus.instance.on<SignIn>().listen((event) {
      var settingCtrl = Get.find<SettingController>();
      _userId = settingCtrl.user?.id ?? "";
      _userName = settingCtrl.user?.name ?? "";
      if (_userId != "") {
        _initialization();
      }
    });
    _signOutSub = XEventBus.instance.on<SignOut>().listen((event) {
      clear();
    });
  }

  @override
  onClose() {
    _signInSub?.cancel();
    _signOutSub?.cancel();
    clear();
    super.onClose();
  }

  clear() {
    _userId = "";
    _groups.clear();
    _chats.clear();
    _curChat.value = null;
  }

  /// 获取名称
  String getName(String id) {
    for (var chatGroup in _groups) {
      for (var chat in chatGroup.chats) {
        if (chat.target.id == id) {
          return chat.target.name;
        }
      }
    }
    return "未知";
  }

  /// 查询组织信息
  TargetShare? findTeamInfoById(String id) {
    // return findTargetShare(id);
    return null;
  }

  /// 获取未读数量
  int getNoReadCount() {
    int sum = 0;
    for (var group in _groups) {
      for (var chat in group.chats) {
        sum += chat.noReadCount.value;
      }
    }
    return sum;
  }

  int getChatSize() {
    return _chats.length;
  }

  /// 移除近期会话
  removeChat(IChat chat) async {
    _chats.remove(chat);
    await _cacheChats();
  }

  /// 通过空间 ID，会话 ID设置
  Future<void> setCurrent(String spaceId, String chatId) async {
    _curChat.value = findChat(spaceId, chatId);
    var curChat = _curChat.value;
    if (curChat != null) {
      curChat.noReadCount.value = 0;
      await curChat.moreMessage();
      if (curChat.persons.isEmpty) {
        await curChat.morePersons();
      }
      _appendChats(curChat);
      await _cacheChats();
    } else {
      _curChat.value = null;
    }
  }

  /// 是否为当前会话
  bool isCurrent(String spaceId, String chatId) {
    return _curChat.value?.spaceId == spaceId &&
        _curChat.value?.chatId == chatId;
  }

  /// 缓存当前会话
  _cacheChats() async {
    var chats = _chats
        .map((c) {
          return c.getCache().toJson();
        })
        .toList()
        .reversed
        .toList();
    Log.info(chats);
    await KernelApi.getInstance().anystore.set(
          "chatsObjectName",
          {
            "operation": "replaceAll",
            "data": {"chats": chats}
          },
          "user",
        );
  }

  /// 初始化监听器
  _initialization() async {
    _groups.addAll(await loadChats(_userId));
    var kennel = KernelApi.getInstance();
    kennel.on('RecvMsg', onReceiveMessage);
    kennel.on('ChatRefresh', chatRefresh);
    kennel.anystore.subscribed('userchat', 'user', _updateMails);
  }

  Future<List<IChatGroup>> loadChats(String userId) async {
    List<IChatGroup> groups = [];
    var res = await KernelApi.getInstance().queryImChats(ChatsReqModel(
      spaceId: userId,
      cohortName: TargetType.cohort.label,
      spaceTypeName: TargetType.company.label,
    ));
    if (res.success) {
      res.data?.groups?.forEach((group) {
        int index = 0;
        var chats = (group.chats ?? [])
            .map((item) => createChat(group.id, item.name, item, userId))
            .toList();
        groups
            .add(BaseChatGroup(group.id, group.name, index++ == 0, chats.obs));
      });
    }
    return groups;
  }

  chatRefresh() async {
    _groups.value = await loadChats(_userId);
    setCurrent(_curChat.value?.spaceId ?? "", _curChat.value?.chatId ?? "");
  }

  /// 更新视图
  _updateMails(dynamic data) {
    List<dynamic> chats = data["chats"] ?? [];
    for (Map<String, dynamic>? chat in chats) {
      if (chat == null) {
        continue;
      }
      var spaceId = chat["spaceId"];
      var chatId = chat["chatId"];
      var matchedChat = findChat(spaceId, chatId);
      if (matchedChat != null) {
        matchedChat.loadCache(ChatCache.fromMap(chat));
        _appendChats(matchedChat);
      }
    }
  }

  /// 获取会话的位置
  _getPositioned(String spaceId, String chatId) {
    return _chats.indexWhere((item) {
      return item.spaceId == spaceId && item.chatId == chatId;
    });
  }

  /// 不存在会话就加入
  _appendChats(IChat targetChat) {
    var position = _getPositioned(targetChat.spaceId, targetChat.chatId);
    if (position == -1) {
      _chats.insert(0, targetChat);
    } else {
      _chats[position] = targetChat;
    }
  }

  /// 获取存在的会话
  IChat? findChat(String spaceId, String chatId) {
    for (var chatGroup in _groups) {
      for (var inner in chatGroup.chats) {
        if (inner.spaceId == spaceId && inner.chatId == chatId) {
          return inner;
        }
      }
    }
    return null;
  }

  /// 设置置顶
  setTopping(IChat targetChat) {
    var position = _getPositioned(targetChat.spaceId, targetChat.chatId);
    if (position != -1) {
      var chat = _chats.removeAt(position);
      _chats.insert(0, chat);
    }
  }

  bool hasNoRead() {
    var has = _chats.firstWhereOrNull((item) => item.noReadCount.value != 0);
    return has != null;
  }

  /// 接受消息
  Future<void> onReceiveMessage(dynamic item) async {
    var message = XImMsg.fromJson(item);
    var sessionId = message.toId;
    if (message.toId == _userId) {
      sessionId = message.fromId;
    }
    for (var group in _groups) {
      for (var one in group.chats) {
        bool isMatched = one.target.id == sessionId;
        if (isMatched && one.target.typeName == TargetType.person.label) {
          isMatched = message.spaceId == one.spaceId;
        }
        if (isMatched) {
          one.receiveMessage(message, _curChat.value != one);
          _appendChats(one);
          _cacheChats();
        }
      }
    }
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController(), permanent: true);
  }
}
