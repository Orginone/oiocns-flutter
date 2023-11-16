import 'dart:async';
import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/activity.dart';

import '../target/team/company.dart';

// 空时间
var nullTime = DateTime.parse('2022-07-01');
// 消息变更推送
var msgChatNotify = Emitter();

/// 会话接口类
abstract class ISession extends IEntity<XEntity> {
  /// 是否归属人员
  late bool isBelongPerson;

  /// 成员是否有我
  late bool isMyChat;

  /// 是否是好友
  late bool isFriend;

  /// 会话id
  late String sessionId;

  /// 会话的用户
  late ITarget target;

  /// 消息类会话元数据
  late MsgChatData chatdata;

  /// 会话描述
  late String information;

  /// 会话的历史消息
  late RxList<IMessage> messages;

  /// 是否为群会话
  late bool isGroup;

  /// 会话的成员
  late RxList<XTarget> members;

  /// 会话动态
  late IActivity activity;

  /// 是否可以删除消息
  late bool canDeleteMessage;

  /// 加载更多历史消息
  Future<int> moreMessage();

  /// 禁用通知
  void unMessage();

  /// 消息变更通知
  void onMessage(Function(List<IMessage> messages)? callback);

  /// 向会话发送消息
  Future<bool> sendMessage(
    MessageType type,
    String text,
    List<String> mentions, {
    IMessage? cite,
    List<IMessage>? forward,
  });

  /// 撤回消息
  Future<void> recallMessage(String id);

  /// 标记消息
  Future<void> tagMessage(List<String> ids, String tag);

  /// 删除消息
  Future<bool> deleteMessage(String id);

  /// 清空历史记录
  Future<bool> clearMessage();

  /// 缓存会话数据
  Future<bool> cacheChatData([bool? notify]);
}

/// 会话实现
class Session extends Entity<XEntity> implements ISession {
  Session(this.sessionId, this.target, this.metadata, {this.tags})
      : super(metadata) {
    sessionId = id;
    if (tags == null) {
      tags = [metadata.typeName!];
      if (metadata.belong != null) {
        tags?.insert(0, metadata.belong!.name ?? "");
      }
    }
    chatdata = MsgChatData(
      fullId: '${target.id}_$id',
      chatName: metadata.name ?? '',
      chatRemark: metadata.remark ?? '',
      isToping: false,
      noReadCount: 0,
      lastMsgTime: 0, //nullTime,
      mentionMe: false,
      labels: id == userId ? ['本人'] : tags ?? [],
      lastMessage: null,
    );
    members = <XTarget>[].obs;
    messages = <IMessage>[].obs;
    activity = Activity(metadata, this);
    if (id != userId) {
      loadCacheChatData();
    }
  }

  @override
  String sessionId;
  @override
  final ITarget target;
  @override
  final XTarget metadata;

  List<String>? tags;

  /// 消息类会话元数据
  @override
  late MsgChatData chatdata;

  /// 会话的历史消息
  @override
  late RxList<IMessage> messages;

  /// 会话的成员
  @override
  late RxList<XTarget> members;
  @override
  late IActivity activity;
  // @override
  // RxList<IMessage> messages = [];
  Function(List<IMessage> messages)? messageNotify;

  XCollection<ChatMessageType> get coll {
    return target.resource.messageColl;
  }

  // @override
  // List<XTarget> get members {
  //   return isGroup ? target.members : [];
  // }

  @override
  bool get isGroup {
    return target.id == sessionId && sessionId != userId;
  }

  dynamic get sessionMatch {
    return isGroup
        ? {"toId": sessionId, "isDeleted": false}
        : {
            "_or_": [
              {"fromId": sessionId, "toId": userId},
              {"fromId": userId, "toId": sessionId},
            ],
          };
  }

  @override
  bool get isBelongPerson {
    return (metadata.belongId == metadata.createUser &&
            target is! ICompany // !('stations' in this.target)
        );
  }

  @override
  bool get isMyChat {
    return (metadata.typeName == TargetType.person.label ||
        members.any((i) => i.id == userId) ||
        chatdata.noReadCount > 0);
  }

  @override
  bool get isFriend {
    return (metadata.typeName != TargetType.person.label ||
        target.user!.members.any((i) => i.id == sessionId));
  }

  @override
  String get remark {
    if (null != chatdata.lastMessage) {
      var msg = Message(chatdata.lastMessage!, this);
      return msg.msgTitle;
    }
    return metadata.remark!.substring(0, 60);
  }

  String? get copyId {
    if (target.id == userId && sessionId != userId) {
      return sessionId;
    }
    return null;
  }

  @override
  String get information {
    if (chatdata.lastMessage != null) {
      var msg = Message(chatdata.lastMessage!, this);
      return msg.msgTitle;
    }
    return metadata.remark!.substring(0, 60);
  }

  String get cachePath {
    return 'session.${chatdata.fullId}';
  }

  @override
  bool get canDeleteMessage {
    return target.id == userId || target.hasRelationAuth();
  }

  @override
  Future<int> moreMessage() async {
    var data = await coll.loadSpace({
      "take": 30,
      "skip": messages.length,
      "options": {
        "match": sessionMatch,
        "sort": {
          "createTime": -1,
        },
      },
    }, ChatMessageType.fromJson);
    if (data.isNotEmpty) {
      for (var msg in data) {
        messages.add(Message(msg, this));
      }
      if (chatdata.lastMsgTime == nullTime) {
        chatdata.lastMsgTime =
            DateTime.parse(data[0].createTime!).millisecondsSinceEpoch;
      }
      return data.length;
    }
    return 0;
  }

  @override
  void unMessage() {
    messageNotify = null;
  }

  @override
  void onMessage(Function(List<IMessage> messages)? callback) {
    messageNotify = callback;
    moreMessage().then((e) async {
      var ids = messages.where((i) => !i.isReaded).map((i) => i.id).toList();
      if (ids.isNotEmpty) {
        tagMessage(ids, '已读');
      }
      chatdata.mentionMe = false;
      if (chatdata.noReadCount > 0) {
        chatdata.noReadCount = 0;
        cacheChatData(true);
      }
      msgChatNotify.changCallback();
      messageNotify?.call(messages);
    });
  }

  @override
  Future<bool> sendMessage(
    MessageType type,
    String text,
    List<String> mentions, {
    IMessage? cite,
    List<IMessage>? forward,
  }) async {
    if (cite != null) {
      cite.metadata.comments = [];
    }
    print(
        '>>>==========================================================================');
    print(
        '>>>KEY:$key ID:$id hashCode:$hashCode belong:$belongId target:${target.id} name:$name');
    print(
        '>>>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    // var createTime = DateTime.now().format(format: 'yyyy-MM-dd HH:mm:ss.SSS');
    var data = await coll.insert(
      ChatMessageType.fromJson({
        "typeName": type.label,
        "fromId": userId,
        "toId": sessionId,
        "comments": [],
        // "createTime": createTime,
        // "updateTime": createTime,
        // "createUser": userId,
        // "updateUser": userId,
        // "status": 1,
        "content": StringGzip.deflate(
          '[obj]${json.encode({
                "body": text,
                "mentions": mentions,
                "cite": cite?.metadata,
              })}',
        ),
      }),
      fromJson: ChatMessageType.fromJson,
    );
    if (data != null) {
      await notify('insert', [data], false);
    }
    return data != null;
  }

  @override
  Future<void> recallMessage(String id) async {
    var data = await coll.update(
      id,
      {
        "_set_": {"typeName": MessageType.recall},
      },
      copyId: copyId,
    );
    if (data != null) {
      await notify('replace', [data]);
    }
  }

  @override
  Future<void> tagMessage(List<String> ids, String tag) async {
    var data = await coll.updateMany(
      ids,
      {
        "_push_": {
          "comments": {
            "label": tag,
            "time": 'sysdate()',
            "userId": userId,
          },
        },
      },
      copyId: copyId,
    );
    if (data != null) {
      await notify('replace', data);
    }
  }

  @override
  Future<bool> deleteMessage(String id) async {
    if (canDeleteMessage) {
      for (var item in messages) {
        if (item.id == id) {
          if (await coll.delete(item.metadata)) {
            var index = messages.indexWhere((i) => i.id == id);
            if (index > -1) {
              messages.removeAt(index);
            }
            chatdata.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
            messageNotify?.call(messages);
            return true;
          }
        }
      }
    }
    return false;
  }

  @override
  Future<bool> clearMessage() async {
    if (canDeleteMessage) {
      var success = await coll.deleteMatch(sessionMatch);
      if (success) {
        messages.clear();
        chatdata.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
        messageNotify?.call(messages);
        sendMessage(MessageType.notify, '${target.user?.name} 清空了消息', []);
        return true;
      }
    }
    return false;
  }

  void receiveMessage(String operate, ChatMessageType data) {
    var imsg = Message(data, this);
    print(
        '>>>==========================================================================');
    print(
        '>>>KEY:$key ID:$id hashCode:$hashCode belong:$belongId target:${target.id} name:$name');
    print(
        '>>>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    if (operate == 'insert') {
      messages.insert(0, imsg);
      if (messageNotify == null) {
        chatdata.noReadCount += imsg.isMySend ? 0 : 1;
        if (!chatdata.mentionMe) {
          chatdata.mentionMe = imsg.mentions.contains(userId);
        }
        msgChatNotify.changCallback();
      } else if (!imsg.isReaded) {
        tagMessage([imsg.id], '已读');
      }
      chatdata.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
      chatdata.lastMessage = data;
      cacheChatData(messageNotify != null && !imsg.isMySend);
    } else {
      var index = messages.indexWhere((i) => i.id == data.id);
      if (index > -1) {
        messages[index] = imsg;
      }
    }
    messageNotify!.call(messages);
  }

  Future<bool> notify(
    String operate,
    List<ChatMessageType> data, [
    bool onlineOnly = true,
  ]) async {
    return await coll.notity(
      {
        "data": data,
        "operate": operate,
      },
      ignoreSelf: false,
      targetId: sessionId,
      onlyTarget: true,
      onlineOnly: onlineOnly,
    );
  }

  Future<void> loadCacheChatData() async {
    var data = await target.user?.cacheObj
        .get<MsgChatData>(cachePath, MsgChatData.fromJson);
    if (data?.fullId == chatdata.fullId) {
      chatdata = data!;
      msgChatNotify.changCallback();
    }
    target.user?.cacheObj.subscribe(chatdata.fullId, (data) {
      if (data.fullId == chatdata.fullId) {
        chatdata = data as MsgChatData;
        target.user?.cacheObj.setValue(cachePath, data);
        command.emitterFlag(flag: 'session');
      }
    });
    _subscribeMessage();
  }

  @override
  Future<bool> cacheChatData([bool? notify = false]) async {
    var success = await target.user?.cacheObj.set(cachePath, chatdata);
    if (success! && notify!) {
      await target.user?.cacheObj.notity(
        chatdata.fullId,
        chatdata,
        onlyTarget: true,
        ignoreSelf: true,
      );
    }
    return success;
  }

  void _subscribeMessage() {
    print(
        '>>>--==========================================================================');
    print(
        '>>>--KEY:$key ID:$id hashCode:$hashCode isGroup:$isGroup belong:$belongId target:${target.id} name:$name');
    print(
        '>>>--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    if (isGroup) {
      coll.subscribe(
        [key],
        (res) => {
          res['data'].forEach((item) =>
              receiveMessage(res['operate'], ChatMessageType.fromJson(item)))
        },
      );
    } else {
      coll.subscribe(
        [key],
        (res) => {
          res['data'].forEach((item) => {
                if ([item.fromId, item.toId].contains(sessionId) &&
                    [item.fromId, item.toId].contains(userId))
                  {
                    receiveMessage(
                        res['operate'], ChatMessageType.fromJson(item))
                  }
              })
        },
        sessionId,
      );
    }
  }

  // Future<void> subscribeOperations() async {
  //   if (isGroup) {
  //     coll.subscribe(
  //       [key],
  //       ({required String operate, required List<ChatMessageType> data}) {
  //         data.map((item) => receiveMessage(operate, item));
  //       },
  //     );
  //   } else {
  //     coll.subscribe(
  //       [key],
  //       ({required String operate, required List<ChatMessageType> data}) {
  //         for (var item in data) {
  //           if ([item.fromId, item.toId].contains(sessionId) &&
  //               [item.fromId, item.toId].contains(userId)) {
  //             receiveMessage(operate, item);
  //           }
  //         }
  //       },
  //       sessionId,
  //     );
  //   }
  // }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
