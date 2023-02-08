import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/dart/core/chat/index.dart';
import 'package:orginone/dart/core/enum.dart';

const chatsObjectName = 'userchat';

class MessageController extends GetxController {
  final Logger log = Logger("MessageController");

  final String _userId = "";
  final RxList<IChatGroup> _groups = <IChatGroup>[].obs;
  final RxList<IChat> _chats = <IChat>[].obs;
  final Rx<IChat?> _curChat = Rxn();

  List<IChatGroup> get groups => _groups;

  List<IChat> get chats => _chats;

  IChat? get chat => _curChat.value;

  String get userId => _userId;

  @override
  void onInit() async {
    super.onInit();
    _initialization();
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
    }
  }

  /// 是否为当前会话
  bool isCurrent(String spaceId, String chatId) {
    return _curChat.value?.spaceId == spaceId &&
        _curChat.value?.chatId == chatId;
  }

  /// 缓存当前会话
  _cacheChats() async {
    await KernelApi.getInstance().anystore.set(
          "chatsObjectName",
          {
            "operation": "replaceAll",
            "data": {
              "chats":
                  _chats.map((c) => c.getCache()).toList().reversed.toList()
            }
          },
          "user",
        );
  }

  /// 初始化监听器
  _initialization() async {
    _groups.value = await loadChats(userId);
    var anystore = KernelApi.getInstance();
    anystore.on('RecvMsg', (message) => onReceiveMessage([message]));
    anystore.on('ChatRefresh', chatRefresh);
    anystore.anystore.subscribed(chatsObjectName, 'user', _updateMails);
  }

  chatRefresh() async {
    _groups.value = await loadChats(userId);
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
        if (inner.chatId == spaceId && inner.spaceId == chatId) {
          return chat;
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

  /// 接受消息
  Future<void> onReceiveMessage(List<dynamic> messages) async {
    for (var item in messages) {
      var message = XImMsg.fromJson(item);
      var sessionId = message.toId;
      if (message.toId == _userId) {
        sessionId = message.fromId;
      }
      for (var chatGroup in _groups) {
        for (var chat in chatGroup.chats) {
          bool isMatched = chat.chatId == sessionId;
          if (isMatched && chat.target.typeName == TargetType.person.label) {
            isMatched = message.spaceId == chat.spaceId;
          }
          if (!isMatched) {
            chat.receiveMessage(message, _curChat.value != chat);
            _appendChats(chat);
            _cacheChats();
          }
        }
      }
    }
  }
}

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}
