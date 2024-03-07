import 'dart:async';
import 'dart:convert';
import 'dart:math';

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
import 'package:orginone/utils/log/log_util.dart';
import 'package:orginone/utils/notification_util.dart';
import 'package:orginone/utils/system/system_utils.dart';

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

  /// 会话主体元数据
  late Rx<MsgChatData> chatdata;

  /// 未读消息数量
  late String noReadCount;

  /// 会话描述
  late String information;

  /// 会话的历史消息
  late RxList<IMessage> messages;

  /// 是否为群会话
  late bool isGroup;

  /// 会话的成员
  late List<XTarget> members;

  /// 会话动态
  late IActivity activity;

  /// 是否可以删除消息
  late bool canDeleteMessage;

  /// 加载更多历史消息
  Future<int> moreMessage();

  /// 禁用通知
  void unMessage();

  /// 消息变更通知
  Future<void> onMessage(Function(List<IMessage> messages)? callback);

  /// 向会话发送消息
  Future<bool> sendMessage(
    MessageType type,
    String text,
    List<String> mentions, [
    IMessage? cite,
    List<IMessage>? forward,
  ]);

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

  /// 刷新消息
  Future<void> refreshMessage();
}

/// 会话实现
class Session extends Entity<XEntity> implements ISession {
  Session(this.sessionId, this.target, this.metadata, {this.tags})
      : super(metadata, tags ?? []) {
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
      lastMsgTime: nullTime.millisecondsSinceEpoch,
      mentionMe: false,
      labels: [],
      lastMessage: null,
      recently: false,
    ).obs;
    // members = <XTarget>[].obs;
    messages = <IMessage>[].obs;
    activity = Activity(metadata, this);
    noReadCount = "";
    newMessageHandler = NewMessageHandler(this);
    // loadCacheChatData();
    Future.delayed(Duration(milliseconds: id == userId ? 100 : 0), () async {
      await _loadCacheChatData();
      await activity.load();
    });
    // if (id != userId) {
    //   loadCacheChatData();
    // }
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
  late Rx<MsgChatData> chatdata;

  /// 未读消息数量
  @override
  late String noReadCount;

  // @override
  // MsgChatData get chatdata {
  //   return _chatdata.value;
  // }

  // @override
  // set chatdata(MsgChatData chatdata) {
  //   _chatdata.value = chatdata;
  // }

  /// 新消息处理器（未读新消息）
  late NewMessageHandler newMessageHandler;

  /// 会话的历史消息
  @override
  late RxList<IMessage> messages;

  /// 会话的成员
  // @override
  // late RxList<XTarget> members;
  @override
  late IActivity activity;
  // @override
  // RxList<IMessage> messages = [];
  Function(List<IMessage> messages)? messageNotify;

  /// 判断是否初始化
  bool isLoaded = false;

  /// 每页条数
  int pageSize = 20;

  XCollection<ChatMessageType> get coll {
    return target.resource.messageColl;
  }

  @override
  List<XTarget> get members {
    return isGroup ? target.members : [];
  }

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
        chatdata.value.noReadCount > 0);
  }

  @override
  bool get isFriend {
    return (metadata.typeName != TargetType.person.label ||
        target.user!.members.any((i) => i.id == sessionId));
  }

  @override
  String get remark {
    if (null != chatdata.value.lastMessage) {
      var msg = Message(chatdata.value.lastMessage!, this);
      return msg.msgTitle;
    }
    return metadata.remark?.substring(0, min(15, metadata.remark!.length)) ??
        "";
  }

  @override
  String get updateTime {
    if (chatdata.value.lastMessage != null) {
      return chatdata.value.lastMessage?.createTime ?? "";
    }
    return super.updateTime;
  }

  String? get copyId {
    if (target.id == userId && sessionId != userId) {
      return sessionId;
    }
    return null;
  }

  @override
  List<String> get groupTags {
    var gtags = [...super.groupTags];
    if (id == userId) {
      gtags.add('本人');
    } else if (isGroup) {
      if (target.space?.id != userId) {
        gtags.add(target.space!.name);
      } else {
        gtags.add(belong.name);
      }
      gtags.add(typeName);
    }
    if (chatdata.value.noReadCount > 0) {
      gtags.add('未读');
    }
    if (chatdata.value.mentionMe) {
      gtags.add('@我');
    }
    if (chatdata.value.isToping) {
      gtags.add('常用');
    }
    return [...gtags, ...chatdata.value.labels];
  }

  @override
  String get information {
    if (chatdata.value.lastMessage != null) {
      var msg = Message(chatdata.value.lastMessage!, this);
      return msg.msgTitle;
    }
    return metadata.remark!.substring(0, min(20, metadata.remark!.length));
  }

  String get cachePath {
    return 'session.${chatdata.value.fullId}';
  }

  @override
  bool get canDeleteMessage {
    return target.id == userId || target.hasRelationAuth();
  }

  @override
  Future<int> moreMessage() async {
    int skip = messages.length;
    var data = await coll.loadSpace({
      "take": pageSize,
      "skip": skip,
      "options": {
        "match": sessionMatch,
        "sort": {
          "createTime": -1,
        },
      },
    }, ChatMessageType.fromJson);
    if (data.isNotEmpty) {
      for (var msg in data) {
        newMessageHandler.put(Message(msg, this));
      }
      readMessages(messages);
      if (chatdata.value.lastMsgTime == nullTime) {
        chatdata.value.lastMessage = data[0];
        chatdata.value.lastMsgTime =
            DateTime.parse(data[0].createTime!).millisecondsSinceEpoch;
        // if (reload) {
        //   await target.user?.cacheObj.all(reload: reload);
        //   await loadCacheChatData();
        // }
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
  Future<void> onMessage(Function(List<IMessage> messages)? callback) async {
    // 判断是否有缓存，有缓存就不执行
    messageNotify = callback;
    if (isLoaded) {
      readMessages(messages);
      return;
    }

    clearCache();
    isLoaded = true;
    // await loadCacheChatData();
    await moreMessage();
    // readMessages(messages);
  }

  void readMessages(List<IMessage> messages, [Message? msg]) {
    var readCount = 0;
    if (null != msg) {
      // if (null != messageNotify) return;

      var index = messages.indexWhere((i) => i.id == msg.id);
      if (index > -1) {
        messages[index] = msg;
        readCount = msg.isMySend ? 0 : 1;
      }
    } else {
      var ids = messages
          .where((i) {
            return !i.isReaded;
          })
          .map((i) => i.id)
          .toList();
      if (ids.isNotEmpty) {
        tagMessage(ids, '已读');
        readCount = chatdata.value.noReadCount > pageSize
            ? pageSize
            : chatdata.value.noReadCount;
        LogUtil.d('>>>>>>>====已读数：$readCount');
      } else {
        readCount = chatdata.value.noReadCount;
      }
    }

    chatdata.value.mentionMe = false;
    if (chatdata.value.noReadCount > 0 && readCount > 0) {
      chatdata.value.noReadCount -= readCount;
      if (null == msg) cacheChatData(true);
      LogUtil.d('>>>>>>>====总已读数：${chatdata.value.noReadCount}');
      refreshNoReadCount();
    }
    LogUtil.d('>>>>>>>======readMessages $readCount $msg ${messages.length}');
    if (readCount > 0 && null != msg) {
      notification();
    }
  }

  @override
  Future<bool> sendMessage(
    MessageType type,
    String text,
    List<String> mentions, [
    IMessage? cite,
    List<IMessage>? forward,
  ]) async {
    if (cite != null) {
      cite.metadata.comments = [];
    }
    if (forward != null && forward.isNotEmpty) {
      forward = forward.map((e) {
        e.metadata.comments = [];
        return e;
      }).toList();
    }
    LogUtil.d(
        '>>>==========================================================================');
    LogUtil.d(
        '>>>KEY:$key ID:$id hashCode:$hashCode belong:$belongId target:${target.id} name:$name');
    LogUtil.d(
        '>>>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    String deviceId = await SystemUtils.getDeviceId();
    var data = await coll.insert(
        ChatMessageType.fromJson({
          "typeName": type.label,
          "fromId": userId,
          "toId": sessionId,
          "comments": [],
          "deviceId": deviceId,
          "content": StringGzip.deflate(
            '[obj]${json.encode({
                  "body": text,
                  "mentions": mentions,
                  "cite": cite?.metadata,
                  'forward': forward?.map((e) => e.metadata).toList()
                })}',
          ),
        }),
        fromJson: ChatMessageType.fromJson,
        copyId: copyId);
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
          "_set_": {"typeName": MessageType.recall.label},
        },
        copyId,
        ChatMessageType.fromJson);
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
        copyId,
        ChatMessageType.fromJson);
    if (data != null && data.isNotEmpty) {
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
            chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
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
        chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
        messageNotify?.call(messages);
        sendMessage(MessageType.notify, '${target.user?.name} 清空了消息', []);
        return true;
      }
    }
    return false;
  }

  /// 刷新消息
  @override
  Future<void> refreshMessage() async {
    clearCache();
    await loadCacheChatData();
    if (null != messageNotify) {
      onMessage((messages) => null);
    }
  }

  /// 清空缓存数据
  void clearCache() {
    isLoaded = false;
    messages.clear();
    newMessageHandler.clear();
    // LogUtil.d('>>>>>>======clear');
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

  Future<void> _loadCacheChatData() async {
    await loadCacheChatData();
    target.user?.cacheObj.subscribe(chatdata.value.fullId, (data) {
      if (data.fullId == chatdata.value.fullId) {
        chatdata.value = data as MsgChatData;
        refreshNoReadCount();
        target.user?.cacheObj.setValue(cachePath, data);
        command.emitterFlag('session-init');
      }
    });
    // LogUtil.d('>>>>=======$key');
    _subscribeMessage();
  }

  Future<void> loadCacheChatData() async {
    // target.user?.cacheObj.clear();
    var data = await target.user?.cacheObj
        .get<MsgChatData>(cachePath, MsgChatData.fromJson);
    if (data?.fullId == chatdata.value.fullId) {
      chatdata.value = data!;
      // LogUtil.d('>>>>>>======loadCacheChatData ${data.toJson()}');
      refreshNoReadCount();
      msgChatNotify.changCallback();
    }
  }

  @override
  Future<bool> cacheChatData([bool? notify = false]) async {
    var success = await target.user?.cacheObj.set(cachePath, chatdata.value);
    if (success! && notify!) {
      await target.user?.cacheObj.notity(
        chatdata.value.fullId,
        chatdata.value,
        onlyTarget: true,
        ignoreSelf: true,
      );
    }
    return success;
  }

  void notification([bool mobilePush = false, IMessage? msg]) {
    command.emitterFlag(
        'session-${chatdata.value.fullId}', [chatdata.value.noReadCount]);
    command.emitterFlag('session');

    msgChatNotify.changCallback();
    messageNotify?.call(messages);

    if (mobilePush && null != msg) {
      NotificationUtil.showChatMessageNotification(msg);
    }
  }

  void addMessage(ChatMessageType data, Message imsg) {
    newMessageHandler.put(imsg, 0);
    chatdata.value.lastMsgTime = DateTime.now().millisecondsSinceEpoch;
    chatdata.value.lastMessage = data;
  }

  void newMessage(ChatMessageType data, Message msg) {
    if (newMessageHandler.hasNoReadMessage(msg)) return;

    addMessage(data, msg);
    if (messageNotify == null) {
      chatdata.value.noReadCount += msg.isMySend ? 0 : 1;
      refreshNoReadCount();
      if (!chatdata.value.mentionMe) {
        chatdata.value.mentionMe = msg.mentions.contains(userId);
      }
      notification(userId != data.fromId, msg);
    } else if (!msg.isReaded) {
      tagMessage([msg.id], '已读');
    }
    cacheChatData(messageNotify != null && !msg.isMySend);
  }

  /// 接收推送消息
  void receiveMessage(String operate, ChatMessageType data) {
    var imsg = Message(data, this);
    LogUtil.d(
        '>>>==========================================================================');
    LogUtil.d(
        '>>>KEY:$key ID:$id hashCode:$hashCode belong:$belongId target:${target.id} name:$name');
    LogUtil.d(
        '>>>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    if (operate == 'insert') {
      newMessage(data, imsg);
    } else {
      readMessages(messages, imsg);
    }
  }

  void refreshNoReadCount() {
    if (chatdata.value.noReadCount > 0) {
      noReadCount = chatdata.value.noReadCount > 99
          ? "99+"
          : chatdata.value.noReadCount.toString();
    } else {
      noReadCount = '';
    }
  }

  void _subscribeMessage() {
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
                if ([item['fromId'], item['toId']].contains(sessionId) &&
                    [item['fromId'], item['toId']].contains(userId))
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

/// 新消息处理器
class NewMessageHandler {
  Session session;

  // 未读消息集合
  List<String> noReadMessageIds = [];

  NewMessageHandler(this.session);

  RxList<IMessage> get messages => session.messages;

  /// 添加消息
  void put(Message message, [int? index]) {
    if (null != index) {
      messages.insert(index, message);
    } else {
      hasNoReadMessage(message);
      messages.add(message);
    }
  }

  bool hasNoReadMessage(IMessage msg) {
    if (!msg.isReaded) {
      if (noReadMessageIds.contains(msg.id)) {
        updateMessage(msg);
        noReadMessageIds.remove(msg.id);
        // LogUtil.d('>>>>>=====remove ${msg.id}');
        return true;
      } else {
        noReadMessageIds.add(msg.id);
        // LogUtil.d('>>>>>=====add ${msg.id}');
        return false;
      }
    } else {
      return false;
    }
  }

  // 更新消息信息
  void updateMessage(IMessage msg) {
    for (var element in messages) {
      if (element.id == msg.id) {
        if (element.isReaded != msg.isReaded) {
          element.isReaded = msg.isReaded;
        }
        break;
      }
    }
  }

  /// 判断是否有消息内容
  bool hasMessage() {
    return session.messages.isNotEmpty;
  }

  void clear() {
    noReadMessageIds.clear();
  }
}
