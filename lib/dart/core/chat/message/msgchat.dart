import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/base/common/entity.dart';
import 'package:orginone/dart/base/common/lists.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/main.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/util/encryption_util.dart';

var nullTime = DateTime(2022, 7, 1).millisecondsSinceEpoch;

/// 单个会话缓存
class MsgChatData {
  String fullId;
  List<String> labels;
  String? chatName;
  String chatRemark;
  bool isToping;
  bool isFindme;
  int noReadCount;
  int lastMsgTime;
  MsgSaveModel? lastMessage;

  MsgChatData({
    required this.fullId,
    required this.labels,
    this.chatName,
    required this.chatRemark,
    required this.isToping,
    required this.isFindme,
    required this.noReadCount,
    required this.lastMsgTime,
    this.lastMessage,
  });

  MsgChatData.fromMap(Map<String, dynamic> map)
      : fullId = map["fullId"],
        labels = map['labels'],
        chatName = map['chatName'],
        chatRemark = map['chatRemark'],
        noReadCount = map["noReadCount"],
        isToping = map["isToping"] ?? false,
        isFindme = map["isFindme"] ?? false,
        lastMsgTime = map["lastMsgTime"],
        lastMessage = map["lastMessage"] == null
            ? null
            : MsgSaveModel.fromJson(map["lastMessage"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["fullId"] = fullId;
    json['labels'] = labels;
    json['chatName'] = chatName;
    json['chatRemark'] = chatRemark;
    json["noReadCount"] = noReadCount;
    json["isToping"] = isToping;
    json["isFindme"] = isFindme;
    json["lastMsgTime"] = lastMsgTime;
    json["lastMessage"] = lastMessage?.toJson();
    return json;
  }
}

class TagsMsgType {
  String belongId;
  String id;
  List<String> ids;
  List<String> tags;

  TagsMsgType({
    required this.belongId,
    required this.id,
    required this.ids,
    required this.tags,
  });

  factory TagsMsgType.fromJson(Map<String, dynamic> json) {
    return TagsMsgType(
      belongId: json['belongId'] as String,
      id: json['id'] as String,
      ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['belongId'] = belongId;
    data['id'] = id;
    data['ids'] = ids;
    data['tags'] = tags;
    return data;
  }
}

/// 单个会话的抽象
abstract class IMsgChat extends IEntity {
  /// 消息类会话元数据
  abstract MsgChatData chatdata;

  /// 回话的标签列表
  abstract List<String> labels;

  /// 会话Id
  abstract String chatId;

  String get userId;

  /// 会话归属Id
  abstract String belongId;

  /// 自归属用户
  abstract IBelong space;

  /// 共享信息
  abstract ShareIcon share;

  /// 会话的历史消息
  abstract List<MsgSaveModel> messages;

  /// 会话的成员
  abstract List<XTarget> members;

  /// 会话的成员的会话
  abstract List<PersonMsgChat> memberChats;

  /// 是否为我的会话
  bool get isMyChat;

  ///禁用通知
  void unMessage();

  /// 会话初始化
  void onMessage(void Function(List<MsgSaveModel>) messages);

  /// 缓存会话
  void cache();

  /// 加载会话缓存
  /// [chatCache] 缓存数据
  void loadCache(MsgChatData chatCache);

  /// 更多消息
  /// [filter] 过滤条件
  Future<int> moreMessage();

  /// 加载成员用户实体
  Future<List<XTarget>> loadMembers({bool reload = false});

  /// 发送消息
  Future<bool> sendMessage(MessageType type, String text);

  /// 撤销消息
  Future<void> recallMessage(String id);

  /// 标记消息
  Future<void> tagMessage(List<String> ids, List<String> tags);

  /// 标记消息
  void tagHasReadMsg(List<MsgSaveModel> ms);

  /// 重写消息标记信息
  overwriteMessagesTags(tagsMsgType);

  /// 删除消息
  Future<bool> deleteMessage(String id);

  /// 清空历史消息
  Future<bool> clearMessage();

  /// 接收消息
  receiveMessage(MsgSaveModel msg);
}

abstract class MsgChat extends Entity implements IMsgChat {
  MsgChat(
    this.belongId,
    this.chatId,
    this.share,
    this.labels,
    String remark,
    IBelong? space, {
    List<String>? findMe,
  })  : chatdata = MsgChatData(
          fullId: "$belongId-$chatId",
          isToping: false,
          isFindme: false,
          noReadCount: 0,
          lastMsgTime: nullTime,
          labels: labels,
          chatName: share.name,
          chatRemark: remark,
        ),
        members = <XTarget>[],
        messages = <MsgSaveModel>[],
        memberChats = <PersonMsgChat>[].obs {
    this.space = space ?? this as IBelong;
  }

  List<String>? findMe;

  @override
  MsgChatData chatdata;

  @override
  List<String> labels;

  @override
  String chatId;

  @override
  String belongId;

  @override
  late IBelong space;

  @override
  ShareIcon share;

  @override
  List<XTarget> members;

  @override
  List<MsgSaveModel> messages;

  @override
  List<PersonMsgChat> memberChats;

  void Function(List<MsgSaveModel> messages)? _messageNotify;

  @override
  String get userId {
    return space.user.id;
  }

  @override
  bool get isMyChat {
    if (chatdata.noReadCount > 0 || share.typeName == TargetType.person.label) {
      return true;
    }
    return members.where((i) => i.id == userId).isNotEmpty;
  }

  @override
  void unMessage() {
    _messageNotify = null;
  }

  @override
  onMessage(void Function(List<MsgSaveModel>) callback) {
    _messageNotify = callback;
    if (chatdata.noReadCount > 0) {
      chatdata.noReadCount = 0;
      cache();
    }
    if (messages.length < 10) {
      moreMessage();
    }
  }

  @override
  cache() {
    kernel.anystore.set(
      "${StoreCollName.chatMessage}.T${chatdata.fullId}",
      {
        "operation": "replaceAll",
        "data": chatdata.toJson(),
      },
      userId,
    );
  }

  @override
  loadCache(MsgChatData cache) {
    if (chatdata.fullId == cache.fullId) {
      chatdata.labels = Lists.union(chatdata.labels, cache.labels);
      chatdata.chatName = cache.chatName ?? chatdata.chatName;
      share.name = chatdata.chatName ?? "";
      ShareIdSet[chatId] = share;
      cache.noReadCount = cache.noReadCount;
      if (chatdata.noReadCount != cache.noReadCount) {
        chatdata.noReadCount = cache.noReadCount;
      }
      chatdata.lastMsgTime = cache.lastMsgTime;
      if (cache.lastMessage?.id != chatdata.lastMessage?.id) {
        chatdata.lastMessage = cache.lastMessage;
        int index = messages.indexWhere((i) => i.id == cache.lastMessage?.id);
        if (index > -1) {
          messages[index] = cache.lastMessage!;
        } else {
          messages.add(cache.lastMessage!);
          _messageNotify!.call(messages);
        }
      }
    }
  }

  @override
  Future<int> moreMessage({String? filter}) async {
    var res = await kernel.anystore.aggregate(
      StoreCollName.chatMessage,
      {
        "match": {
          "sessionId": chatId,
          "belongId": belongId,
        },
        "sort": {
          "createTime": -1,
        },
        "skip": messages.length,
        "limit": 30,
      },
      userId,
    );
    if (res.success) {
      _loadMessages(res.data);
      return res.data.length;
    }
    return 0;
  }

  @override
  Future<bool> sendMessage(MessageType type, String msgBody) async {
    var res = await kernel.createImMsg(MsgSendModel(
      msgType: type.label,
      toId: chatId,
      belongId: belongId,
      msgBody: EncryptionUtil.deflate(msgBody),
    ));
    return res.success;
  }

  @override
  Future<void> recallMessage(String id) async {
    var message = messages.firstWhere((element) => element.id == id);
    await kernel.recallImMsg(message);
  }

  @override
  Future<void> tagMessage(List<String> ids, List<String> tags) async {
    if (ids.isNotEmpty && tags.isNotEmpty) {
      await kernel.tagImMsg(MsgTagModel(
        belongId: belongId,
        id: chatId,
        ids: ids,
        tags: tags,
      ));
    }
  }

  @override
  Future<bool> deleteMessage(String id) async {
    var res = await kernel.anystore.remove(
      StoreCollName.chatMessage,
      {"chatId": id},
      userId,
    );
    if (res.success) {
      messages.removeWhere((item) => item.id == id);
      chatdata.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
      _messageNotify?.call(messages);
      return true;
    }
    return res.success;
  }

  @override
  Future<bool> clearMessage() async {
    var res = await kernel.anystore.remove(
      StoreCollName.chatMessage,
      {
        "sessionId": chatId,
        "belongId": belongId,
      },
      userId,
    );
    if (res.success) {
      messages.clear();
      chatdata.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
      _messageNotify?.call(messages);
      return true;
    }
    return res.success;
  }

  @override
  void tagHasReadMsg(List<MsgSaveModel> ms) {}

  @override
  overwriteMessagesTags(tagsMsgType) {}

  @override
  receiveMessage(MsgSaveModel msg) {
    if (msg.msgType == "recall") {
      msg.showTxt = '撤回一条消息';
      msg.allowEdit = true;
      msg.msgBody = EncryptionUtil.inflate(msg.msgBody);
      int index = messages.indexWhere((item) => item.id == msg.id);
      if (index > -1) {
        messages[index] = msg;
      }
    } else {
      msg.showTxt = EncryptionUtil.inflate(msg.msgBody);
      messages.insert(0, msg);
    }
    chatdata.noReadCount += 1;

    chatdata.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
    chatdata.lastMessage = msg;
    cache();

    _messageNotify?.call(messages);
  }

  void _loadMessages(List<dynamic> msgs) {
    for (var msg in msgs) {
      var item = MsgSaveModel.fromJson(msg);
      item.showTxt = EncryptionUtil.inflate(item.msgBody);
      messages.insert(0, item);
    }
    if (chatdata.lastMsgTime == nullTime && msgs.isNotEmpty) {
      var time = DateTime.parse(msgs[0].createTime).millisecondsSinceEpoch;
      chatdata.lastMsgTime = time;
    }
    if (_messageNotify != null) {
      _messageNotify!(messages);
    }
  }
}

class PersonMsgChat extends MsgChat {
  PersonMsgChat(
    super.belongId,
    super.chatId,
    super.share,
    super.labels,
    super.remark,
    super.space,
  );

  @override
  Future<List<XTarget>> loadMembers({bool reload = true}) async {
    return [];
  }
}
