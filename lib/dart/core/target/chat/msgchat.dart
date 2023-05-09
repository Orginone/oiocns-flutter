import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/util/encryption_util.dart';

import '../../market/model.dart';

const hisMsgCollName = 'chat-message';
var nullTime = DateTime(2022, 7, 1).millisecondsSinceEpoch;

/// 单个会话的抽象
abstract class IChat {
  late Rx<ChatCache> chatdata;
  late String userId;
  late String chatId;
  late String belongId;
  late RxList<XImMsg> messages;
  late RxList<XTarget> members;
  late TargetShare shareInfo;
  late RxList<PersonMsgChat> memberChats;

  bool get isMyChat;

  ///禁用通知
  void unMessage();

  /// 缓存会话
  cache();

  /// 会话初始化
  onMessage();

  /// 加载会话缓存
  /// [chatCache] 缓存数据
  loadCache(ChatCache chatCache);

  /// 更多消息
  /// [filter] 过滤条件
  Future<int> moreMessage({String? filter});

  /// 发送消息
  Future<bool> sendMessage(MessageType type, String msgBody);

  /// 撤销消息
  Future<void> recallMessage(String id);

  //标记消息
  Future<void> tagMessage(List<String> ids, List<String> tags);

  //加载成员用户实体
  Future<List<XTarget>> loadMembers({bool reload = false});

  /// 删除消息
  Future<bool> deleteMessage(String id);

  /// 清空历史消息
  Future<bool> clearMessage();

  /// 接收消息
  receiveMessage(XImMsg msg);
}

abstract class MsgChat implements IChat {
  MsgChat(this.userId, this.belongId, this.chatId, this.shareInfo,
      List<String> labels, String remark) {
    chatdata = Rx(ChatCache(
      fullId: "$belongId-$chatId",
      isTopping: false,
      noReadCount: 0,
      lastMsgTime: nullTime,
      labels: labels,
      chatName: shareInfo.name,
      chatRemark: remark,
    ));
    members = <XTarget>[].obs;
    messages = <XImMsg>[].obs;
    memberChats = <PersonMsgChat>[].obs;
  }

  @override
  cache() {
    kernel.anystore.set(
      "$hisMsgCollName.T${chatdata.value.fullId}",
      {"operation": "replaceAll", "data": chatdata.value.toJson()},
      '0',
    );
  }

  @override
  Future<bool> clearMessage() async {
    var res = await kernel.anystore.remove(
        hisMsgCollName, {"sessionId": chatId, "belongId": belongId}, '0');
    if (res.success) {
      messages.clear();
      chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
      messages.refresh();
    }
    return res.success;
  }

  @override
  Future<bool> deleteMessage(String id) async {
    var res = await kernel.anystore.remove(hisMsgCollName, {"chatId": id}, '0');
    if (res.success) {
      messages.removeWhere((item) => item.id == id);
      chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
      messages.refresh();
    }
    return res.success;
  }

  @override
  loadCache(ChatCache cache) {
    if (chatdata.value.fullId == cache.fullId) {
      chatdata.value.labels = cache.labels ?? chatdata.value.labels;
      chatdata.value.chatName = cache.chatName ?? chatdata.value.chatName;
      shareInfo.name = chatdata.value.chatName ?? "";
      cache.noReadCount = cache.noReadCount ?? chatdata.value.noReadCount;
      if (chatdata.value.noReadCount != cache.noReadCount) {
        chatdata.value.noReadCount = cache.noReadCount;
        chatdata.refresh();
      }
      if (cache.lastMsgTime != null) {
        chatdata.value.lastMsgTime = cache.lastMsgTime;
      }
      if (cache.lastMessage?.id != chatdata.value.lastMessage?.id) {
        chatdata.value.lastMessage = cache.lastMessage;
        int index = messages.indexWhere((i) => i.id == cache.lastMessage?.id);
        if (index > -1) {
          messages[index] = cache.lastMessage!;
        } else {
          messages.add(cache.lastMessage!);
        }
        messages.refresh();
      }
    }
  }

  @override
  Future<int> moreMessage({String? filter}) async {
    var res = await kernel.anystore.aggregate(
        hisMsgCollName,
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
        userId);
    if (res.success) {
      _loadMessages(res.data);
      return res.data.length;
    }
    return 0;
  }

  @override
  onMessage() {
    if (chatdata.value.noReadCount > 0) {
      chatdata.value.noReadCount = 0;
    }
    cache();
    if (messages.length < 10) {
      moreMessage();
    }
  }

  @override
  Future<void> recallMessage(String id) async {
    try {
      var message = messages.firstWhere((element) => element.id == id);
      var msg = await kernel.recallImMsg(message);
      if (msg.success) {
        messages.remove(message);
        messages.refresh();
      }
    } catch (e) {}
  }

  @override
  receiveMessage(XImMsg msg) {
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
    chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
    chatdata.value.noReadCount += 1;
    chatdata.value.lastMessage = msg;
    chatdata.refresh();
    cache();
  }

  @override
  Future<bool> sendMessage(MessageType type, String msgBody) async {
    var res = await kernel.createImMsg(ImMsgModel(
      msgType: type.label,
      msgBody: EncryptionUtil.deflate(msgBody),
      belongId: belongId,
      toId: chatId,
    ));
    return res.success;
  }

  @override
  Future<void> tagMessage(List<String> ids, List<String> tags) async {
    if (ids.isNotEmpty && tags.isNotEmpty) {
      await kernel.tagImMsg(
          MsgTagModel(belongId: belongId, id: chatId, ids: ids, tags: tags));
    }
  }

  @override
  void unMessage() {
    // TODO: implement unMessage
  }

  void _loadMessages(List<dynamic> msgs) {
    for (var item in msgs) {
      item["id"] = item["chatId"];
      var detail = XImMsg.fromJson(item);
      detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
      messages.insert(0, detail);
    }
    if (chatdata.value.lastMsgTime == nullTime && msgs.isNotEmpty) {
      chatdata.value.lastMsgTime =
          DateTime.tryParse(msgs[0].createTime ?? "")?.millisecondsSinceEpoch;
    }
    chatdata.refresh();
  }

  @override
  late String belongId;

  @override
  late String chatId;

  @override
  late Rx<ChatCache> chatdata;

  @override
  late TargetShare shareInfo;

  @override
  late String userId;

  @override
  late RxList<XTarget> members;

  @override
  late RxList<XImMsg> messages;

  @override
  late RxList<PersonMsgChat>  memberChats;

  @override
  // TODO: implement isMyChat
  bool get isMyChat {
    if (chatdata.value.noReadCount > 0 ||
        shareInfo.typeName == TargetType.person.label) {
      return true;
    }
    return members.where((i) => i.id == userId).isNotEmpty;
  }

}

class PersonMsgChat extends MsgChat {
  PersonMsgChat(super.userId, super.belongId, super.chatId, super.shareInfo,
      super.labels, super.remark);

  @override
  Future<List<XTarget>> loadMembers({bool reload = true}) async{
    return [];
  }
}

/// 单个会话缓存
class ChatCache {
  String fullId;
  bool isTopping;
  int noReadCount;
  int? lastMsgTime;
  XImMsg? lastMessage;
  List<String>? labels;
  String? chatName;
  String? chatRemark;

  ChatCache({
    required this.fullId,
    required this.isTopping,
    required this.noReadCount,
    this.lastMsgTime,
    this.lastMessage,
    this.chatName,
    this.chatRemark,
    this.labels,
  });

  ChatCache.fromMap(Map<String, dynamic> map)
      : fullId = map["fullId"],
        noReadCount = map["noReadCount"],
        isTopping = map["isToping"] ?? false,
        lastMsgTime = map["lastMsgTime"],
        chatName = map['chatName'],
        chatRemark = map['chatRemark'],
        labels = map['labels'],
        lastMessage = map["lastMessage"] == null
            ? null
            : XImMsg.fromJson(map["lastMessage"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["fullId"] = fullId;
    json["isToping"] = isTopping;
    json["noReadCount"] = noReadCount;
    json["lastMsgTime"] = lastMsgTime;
    json['chatName'] = chatName;
    json['chatRemark'] = chatRemark;
    json['labels'] = labels;
    json["lastMessage"] = lastMessage?.toJson();
    return json;
  }
}
