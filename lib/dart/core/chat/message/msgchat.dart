import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/base/common/entity.dart';
import 'package:orginone/dart/base/common/lists.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chat.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/notification_util.dart';
import 'package:orginone/util/toast_utils.dart';

import 'message.dart';

var nullTime = DateTime(2022, 7, 1).millisecondsSinceEpoch;

/// 单个会话缓存
class MsgChatData {
  String fullId;
  List<String> labels;
  String? chatName;
  String chatRemark;
  bool isToping;
  dynamic isFindme;
  int noReadCount;
  int lastMsgTime;
  MsgSaveModel? lastMessage;
  bool mentionMe;

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
    this.mentionMe = false,
  });

  MsgChatData.fromMap(Map<String, dynamic> map)
      : fullId = map["fullId"],
        labels = [],
        chatName = map['chatName'],
        chatRemark = map['chatRemark'],
        noReadCount = map["noReadCount"],
        isToping = map["isToping"] ?? false,
        isFindme = map["isFindme"],
        lastMsgTime = map["lastMsgTime"],
        mentionMe = map['mentionMe'] ?? false,
        lastMessage = map["lastMessage"] == null
            ? null
            : MsgSaveModel.fromJson(map["lastMessage"]) {
    if (map['labels'] != null) {
      map['labels'].forEach((str) {
        labels.add(str);
      });
    }
  }

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
  abstract Rx<MsgChatData> chatdata;

  /// 回话的标签列表
  abstract List<String> labels;

  /// 会话Id
  abstract String chatId;

  String get userId;

  /// 会话归属Id
  abstract XTarget belong;

  /// 自归属用户
  abstract IBelong space;

  //是否归属人员用户
  bool get isBelongPerson;

  /// 共享信息
  abstract ShareIcon share;

  /// 会话的历史消息
  abstract RxList<IMessage> messages;

  /// 会话的成员
  abstract RxList<XTarget> members;

  /// 会话的成员的会话
  abstract List<PersonMsgChat> memberChats;

  /// 是否为我的会话
  bool get isMyChat;

  /// 会话初始化
  void onMessage();

  /// 缓存会话
  Future<void> cache();

  /// 加载会话缓存
  /// [chatCache] 缓存数据
  void loadCache(MsgChatData chatCache);

  /// 更多消息
  /// [filter] 过滤条件
  Future<int> moreMessage();

  /// 加载成员用户实体
  Future<List<XTarget>> loadMembers({bool reload = false});

  /// 发送消息
  Future<bool> sendMessage(MessageType type, String text,
      [List<String> mentions = const [], MsgSaveModel? cite]);

  /// 撤销消息
  Future<void> recallMessage(String id);

  /// 标记消息
  Future<void> tagMessage(List<String> ids, List<String> tags);

  /// 标记消息
  void tagHasReadMsg(List<MsgSaveModel> ms);

  /// 重写消息标记信息
  overwriteMessagesTags(TagsMsgType tagsMsgType);

  /// 删除消息
  Future<bool> deleteMessage(String id);

  /// 清空历史消息
  Future<bool> clearMessage();

  /// 接收消息
  void receiveMessage(MsgSaveModel msg, bool isCurrentSession);

  void receiveTags(List<String> ids, List<String> tags);
}

abstract class MsgChat extends Entity implements IMsgChat {
  MsgChat(
    this.belong,
    this.chatId,
    this.share,
    this.labels,
    String remark,
    IBelong? space, {
    List<String>? findMe,
  })  : chatdata = MsgChatData(
          fullId: "${belong.id}-$chatId",
          isToping: false,
          isFindme: false,
          noReadCount: 0,
          lastMsgTime: nullTime,
          labels: labels,
          chatName: share.name,
          chatRemark: remark,
        ).obs,
        members = <XTarget>[].obs,
        messages = <IMessage>[].obs,
        memberChats = <PersonMsgChat>[].obs {
    this.space = space ?? this as IBelong;
  }

  MessageChatController get controller => Get.find();

  List<String>? findMe;

  @override
  Rx<MsgChatData> chatdata;

  @override
  List<String> labels;

  @override
  String chatId;

  @override
  XTarget belong;

  @override
  late IBelong space;

  @override
  ShareIcon share;

  @override
  RxList<XTarget> members;

  @override
  RxList<IMessage> messages;

  @override
  List<PersonMsgChat> memberChats;

  List<String> _newTagInfo = [];

  @override
  String get userId {
    return space.user.id;
  }

  @override
  bool get isMyChat {
    if (chatdata.value.noReadCount > 0 ||
        share.typeName == TargetType.person.label) {
      return true;
    }
    return members.where((i) => i.id == userId).isNotEmpty;
  }

  @override
  onMessage() async {
    settingCtrl.chat.currentChat = this;
    if (chatdata.value.noReadCount > 0) {
      chatdata.value.noReadCount = 0;
      await cache();
    }
    if (messages.length < 10) {
      await moreMessage();
    }
    chatdata.refresh();
  }

  @override
  Future<void> cache() async {
    chatdata.value.labels = labels;
    var res = await kernel.anystore.set(
      "${StoreCollName.chatMessage}.T${chatdata.value.fullId}",
      {
        "operation": "replaceAll",
        "data": chatdata.toJson(),
      },
      userId,
    );
    if (chatdata.value.noReadCount == 0) {
      await kernel.anystore.set(
        "${StoreCollName.chatMessage}.Changed",
        {
          "operation": "replaceAll",
          "data": chatdata.toJson(),
        },
        userId,
      );
    }
    if (!res.success) {
      ToastUtils.showMsg(msg: res.msg);
    }
    print(
        "code------------------${"${StoreCollName.chatMessage}.T${chatdata.value.fullId}"}");
    print("data------------------${chatdata.toJson()}");
  }

  @override
  loadCache(MsgChatData cache) {
    if (chatdata.value.fullId == cache.fullId) {
      labels = (Set<String>.from(labels)..addAll(cache.labels ?? [])).toList();
      chatdata.value.chatName = cache.chatName ?? chatdata.value.chatName;
      share.name = chatdata.value.chatName ?? "";
      if (chatdata.value.noReadCount != cache.noReadCount) {
        chatdata.value.noReadCount = cache.noReadCount;
      }
      chatdata.value.lastMsgTime = cache.lastMsgTime;
      chatdata.value.lastMessage = cache.lastMessage;
    }
    chatdata.refresh();
  }

  @override
  Future<int> moreMessage({String? filter}) async {
    var res = await kernel.anystore.aggregate(
      StoreCollName.chatMessage,
      {
        "match": {
          "sessionId": chatId,
          "belongId": belong.id,
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
  Future<bool> sendMessage(MessageType type, String msgBody,
      [List<String> mentions = const [], MsgSaveModel? cite]) async {
    Map<String, dynamic> data = {
      "body": msgBody,
      "mentions": mentions,
      'cite': cite?.toJson(),
    };

    var res = await kernel.createImMsg(MsgSendModel(
      msgType: type.label,
      toId: chatId,
      belongId: belong.id,
      msgBody: EncryptionUtil.deflate("[obj]${jsonEncode(data)}"),
    ));
    return res.success;
  }

  @override
  Future<void> recallMessage(String id) async {
    var message = messages.firstWhere((element) => element.id == id);
    await kernel.recallImMsg(message.metadata);
  }

  @override
  Future<void> tagMessage(List<String> ids, List<String> tags) async {
    if (ids.isNotEmpty && tags.isNotEmpty) {
      await kernel.tagImMsg(MsgTagModel(
        belongId: belong.id,
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
      chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
      try {
        chatdata.value.lastMessage = messages.last.metadata;
      } catch (e) {
        chatdata.value.lastMessage = null;
      }
      chatdata.refresh();
      await cache();
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
        "belongId": belong.id,
      },
      userId,
    );
    if (res.success) {
      messages.clear();
      chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
      chatdata.value.lastMessage = null;
      chatdata.refresh();
      await cache();
      return true;
    }
    return res.success;
  }

  @override
  void tagHasReadMsg(List<MsgSaveModel> ms) {
    if (!isMyChat) {
      return;
    }
    var needTagMsgs = ms.where((element) {
      if (belong.id != element.belongId || element.fromId == userId) {
        return false;
      }
      // 会话信息是否包含标签
      if (element.tags == null) {
        return true;
      }
      return !element.tags!.any((s) => s.userId == userId && s.label == '已读');
    }).toList();

    if (needTagMsgs.isNotEmpty) {
      var willtagMsgIds = needTagMsgs.map((e) => e.id).toSet();
      if (_newTagInfo.join('-') == willtagMsgIds.join('-')) {
        return;
      }
      _newTagInfo = willtagMsgIds.toList();
      // 触发事件
      tagMessage(_newTagInfo, ['已读']);
    }
  }

  @override
  overwriteMessagesTags(TagsMsgType tagsMsgType) {
    if (tagsMsgType.id != chatId) {
      return;
    }
    for (var msg in messages) {
      if (tagsMsgType.tags[0] == '已读' && msg.metadata.tags == null) {
        msg.metadata.tags = [
          Tag(label: '已读', userId: tagsMsgType.id, time: '')
        ];
      }
      return msg;
    }
    messages.refresh();
  }

  @override
  receiveMessage(MsgSaveModel msg, bool isCurrentSession) async {
    var imsg = Message(this, msg);
    if (imsg.msgType == MessageType.recall.label) {
      try {
        messages.firstWhere((p0) => p0.id == imsg.id).recall();
      } catch (e) {
        messages.insert(0, imsg);
      }
    } else if (imsg.msgType == MessageType.file.label ||
        imsg.msgType == MessageType.image.label) {
      String name = msg.body?.name ?? "";
      var index = messages.indexWhere((p0) => p0.body?.name == name);
      if (index != -1) {
        messages[index] = imsg;
        messages.refresh();
      } else {
        print('');
        messages.insert(0, imsg);
      }
    } else {
      messages.insert(0, imsg);
    }
    if (userId != msg.fromId && !isCurrentSession) {
      chatdata.value.noReadCount += 1;
      NotificationUtil.showChatMessageNotification(msg);
    }
    if (isCurrentSession) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.markVisibleMessagesAsRead();
      });
    }

    chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
    chatdata.value.lastMessage = msg;
    chatdata.value.isFindme = msg.body?.mentions?.contains(settingCtrl.user.id);
    await cache();
    chatdata.refresh();
  }

  void _loadMessages(List<dynamic> msgs) {
    for (var msg in msgs) {
      var item = MsgSaveModel.fromJson(msg);
      messages.add(Message(this, item));
    }
    if (chatdata.value.lastMsgTime == nullTime && msgs.isNotEmpty) {
      var time = DateTime.parse(msgs[0].createTime).millisecondsSinceEpoch;
      chatdata.value.lastMsgTime = time;
    }
    chatdata.refresh();
  }

  @override
  void receiveTags(List<String> ids, List<String> tags) async {
    if (ids.isNotEmpty && tags.isNotEmpty) {
      for (var id in ids) {
        try {
          var message = messages.firstWhere((m) => m.id == id);
          message.receiveTags(tags);
          messages.refresh();
          await cache();
        } catch (e) {}
      }
    }
  }

  @override
  // TODO: implement isBelongPerson
  bool get isBelongPerson => belong.typeName == TargetType.person.label;
}

class PersonMsgChat extends MsgChat {
  PersonMsgChat(
    super.belong,
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
