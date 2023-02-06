import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/util/encryption_util.dart';

const hisMsgCollName = 'chat-message';

class BaseChat implements IChat {
  static final Logger log = Logger("BaseChat");
  final String _userId;
  final String _fullId;
  final String _chatId;
  final String _spaceId;
  final String _spaceName;
  final RxBool _isTopping;
  final RxInt _noReadCount;
  final RxInt _personCount;
  final ChatModel _target;
  final RxList<XImMsg> _messages;
  final RxList<XTarget> _persons;
  final Rx<XImMsg?> _lastMessage;

  BaseChat({
    required String spaceId,
    required String spaceName,
    required ChatModel target,
    required String userId,
    int noReadCount = 0,
    int personCount = 0,
    List<XImMsg> messages = const [],
    List<XTarget> persons = const [],
    XImMsg? lastMessage,
  })  : _userId = userId,
        _chatId = target.id,
        _spaceId = spaceId,
        _spaceName = spaceName,
        _isTopping = false.obs,
        _noReadCount = noReadCount.obs,
        _personCount = personCount.obs,
        _target = target,
        _messages = messages.obs,
        _persons = persons.obs,
        _lastMessage = lastMessage.obs,
        _fullId = '$spaceId-${target.id}' {
    appendShare(target.id, shareInfo());
  }

  @override
  String get userId => _userId;

  @override
  String get chatId => _chatId;

  @override
  int get noReadCount => _noReadCount.value;

  @override
  int get personCount => _personCount.value;

  @override
  XImMsg? get lastMessage => _lastMessage.value;

  @override
  List<XImMsg> get messages => _messages;

  @override
  List<XTarget> get persons => _persons;

  @override
  String get spaceId => _spaceId;

  @override
  String get spaceName => _spaceName;

  @override
  ChatModel get target => _target;

  @override
  String get fullId => _fullId;

  @override
  bool get isTopping => _isTopping.value;

  TargetShare shareInfo() {
    return TargetShare(
      name: target.name,
      typeName: target.typeName,
      avatar: parseAvatar(target.photo),
    );
  }

  @override
  ChatCache getCache() {
    return ChatCache(
      chatId: chatId,
      spaceId: spaceId,
      noReadCount: _noReadCount.value,
      lastMessage: _lastMessage.value,
      isTopping: _isTopping.value,
    );
  }

  @override
  loadCache(ChatCache cache) {
    if (cache.lastMessage?.id != lastMessage?.id) {
      if (cache.lastMessage != null) {
        _messages.insert(0, cache.lastMessage!);
      }
    }
    _isTopping.value = cache.isTopping;
    _noReadCount.value = cache.noReadCount;
    _lastMessage.value = cache.lastMessage;
  }

  @override
  clearMessage() async {
    if (spaceId == userId) {
      var res = await KernelApi.getInstance().anystore.remove(
          hisMsgCollName, {"sessionId": target.id, "spaceId": spaceId}, 'user');
      if (res.success) {
        _messages.clear();
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> deleteMessage(String id) async {
    if (userId == spaceId) {
      var res = await KernelApi.getInstance()
          .anystore
          .remove(hisMsgCollName, {"chatId": id}, 'user');
      if (res.success && res.data > 0) {
        _messages.removeWhere((item) => item.id == id);
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> recallMessage(String id) async {
    for (var message in _messages) {
      if (message.id == id) {
        await KernelApi.getInstance().recallImMsg(message);
      }
    }
  }

  @override
  Future<void> morePersons({String? filter}) async {
    return;
  }

  @override
  Future<int> moreMessage({String? filter}) async {
    return 0;
  }

  @override
  Future<bool> sendMessage({
    required MessageType type,
    required String msgBody,
  }) async {
    var res = await KernelApi.getInstance().createImMsg(ImMsgModel(
      msgType: type.keyword,
      msgBody: EncryptionUtil.deflate(msgBody),
      spaceId: _spaceId,
      fromId: _userId,
      toId: _chatId,
    ));
    return res.success;
  }

  @override
  receiveMessage(XImMsg msg, bool noRead) async {
    if (msg.msgType == "recall") {
      msg.showTxt = '撤回一条消息';
      msg.allowEdit = true;
      msg.msgBody = EncryptionUtil.inflate(msg.msgBody);
      int index = _messages.indexWhere((item) => item.id == msg.id);
      if (index > -1) {
        _messages[index] = msg;
      }
    } else {
      msg.showTxt = EncryptionUtil.inflate(msg.msgBody);
      _messages.insert(0, msg);
    }
    _noReadCount.value += noRead ? 1 : 0;
    _lastMessage.value = msg;
  }

  loadMessages(List<dynamic> messages) {
    for (var message in messages) {
      message["id"] = message["chatId"];
      var detail = XImMsg.fromJson(message);
      detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
      _messages.add(detail);
    }
  }

  Future<int> loadCacheMessages() async {
    var res = await KernelApi.getInstance().anystore.aggregate(
          hisMsgCollName,
          {
            "match": {
              "sessionId": target.id,
              "spaceId": spaceId,
            },
            "sort": {"createTime": -1},
            "skip": _messages.length,
            "limit": 30
          },
          'user',
        );
    if (res.success) {
      loadMessages(res.data);
      return res.data.length;
    }
    return 0;
  }

  @override
  readAll() {
    _noReadCount.value = 0;
  }
}

class PersonChat extends BaseChat {
  PersonChat({
    required super.spaceId,
    required super.spaceName,
    required super.target,
    required super.userId,
  });

  @override
  Future<int> moreMessage({String? filter}) async {
    if (_spaceId == _userId) {
      return await loadCacheMessages();
    } else {
      var res = await KernelApi.getInstance().queryFriendImMsgs(IdSpaceReq(
        id: target.id,
        spaceId: spaceId,
        page: PageRequest(
          limit: 30,
          offset: _messages.length,
          filter: filter ?? "",
        ),
      ));
      if (res.success && res.data != null && res.data?.result != null) {
        for (var detail in res.data!.result!) {
          detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
          _messages.add(detail);
        }
        return res.data!.result!.length;
      }
    }
    return 0;
  }
}

class CohortChat extends BaseChat {
  CohortChat({
    required super.spaceId,
    required super.spaceName,
    required super.target,
    required super.userId,
  });

  @override
  moreMessage({String? filter}) async {
    if (spaceId == userId) {
      return await loadCacheMessages();
    } else {
      var params = IDBelongReq(
        id: target.id,
        page: PageRequest(
          limit: 30,
          offset: _messages.length,
          filter: filter ?? "",
        ),
      );
      var res = await KernelApi.getInstance().queryCohortImMsgs(params);
      if (res.success && res.data != null && res.data?.result != null) {
        for (var detail in res.data!.result!) {
          detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
          _messages.add(detail);
        }
        return res.data!.result!.length;
      }
    }
    return 0;
  }

  @override
  morePersons({String? filter}) async {
    var res = await KernelApi.getInstance().querySubTargetById(IDReqSubModel(
      id: target.id,
      typeNames: [target.typeName],
      subTypeNames: [TargetType.person.label],
      page: PageRequest(
        limit: 14,
        offset: _persons.length,
        filter: filter ?? "",
      ),
    ));
    if (res.success && res.data != null && res.data?.result != null) {
      for (var target in res.data!.result!) {
        target.name = target.team?.name ?? target.name;
        _persons.add(target);
      }
      _personCount.value = res.data?.total ?? 0;
    }
  }
}

class BaseChatGroup implements IChatGroup {
  final String _spaceId;
  final String _spaceName;
  final RxBool _isOpened;
  final RxList<IChat> _chats;

  BaseChatGroup({
    required String spaceId,
    required String spaceName,
    bool isOpened = true,
    List<IChat> chats = const [],
  })  : _spaceId = spaceId,
        _spaceName = spaceName,
        _isOpened = isOpened.obs,
        _chats = chats.obs;

  @override
  String get spaceId => _spaceId;

  @override
  String get spaceName => _spaceName;

  @override
  bool get isOpened => _isOpened.value;

  @override
  List<IChat> get chats => _chats.toList();
}

IChat createChat(
  String spaceId,
  String spaceName,
  ChatModel target,
  String userId,
) {
  if (target.typeName == TargetType.person.label) {
    return PersonChat(
      spaceId: spaceId,
      spaceName: spaceName,
      target: target,
      userId: userId,
    );
  } else {
    return CohortChat(
      spaceId: spaceId,
      spaceName: spaceName,
      target: target,
      userId: userId,
    );
  }
}
