import 'package:flutter/material.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/controller/mapping_to_ui.dart';

/// 会话组的抽象
abstract class IChatGroup<W extends Widget> implements MappingToUI<W> {
  final String spaceId;
  final String spaceName;
  final bool isOpened;
  final List<IChat> chats;

  IChatGroup({
    required this.spaceId,
    required this.spaceName,
    required this.isOpened,
    required this.chats,
  });

  openOrNot(bool isOpened);
}

/// 单个会话缓存
class ChatCache {
  final String chatId;
  final String spaceId;
  final int noReadCount;
  final MessageDetail? lastMessage;

  const ChatCache({
    required this.chatId,
    required this.spaceId,
    required this.noReadCount,
    this.lastMessage,
  });

  ChatCache.fromMap(Map<String, dynamic> map)
      : chatId = map["chatId"],
        spaceId = map["spaceId"],
        noReadCount = map["noReadCount"],
        lastMessage = map["lastMessage"] == null
            ? null
            : MessageDetail.fromMap(map["lastMessage"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["chatId"] = chatId;
    json["spaceId"] = spaceId;
    json["noReadCount"] = noReadCount;
    json["lastMessage"] = lastMessage?.toJson();
    return json;
  }
}

/// 单个会话的抽象
abstract class IChat<W extends Widget> implements MappingToUI<W> {
  final String chatId;
  final String spaceId;
  final String spaceName;
  final int noReadCount;
  final int personCount;
  final MessageTarget target;
  final List<MessageDetail> messages;
  final List<Target> persons;
  final MessageDetail? lastMessage;

  IChat({
    required this.chatId,
    required this.spaceId,
    required this.spaceName,
    required this.noReadCount,
    required this.personCount,
    required this.target,
    required this.messages,
    required this.persons,
    required this.lastMessage,
  });

  /// 获取会话缓存
  ChatCache getCache();

  /// 加载会话缓存
  loadCache(ChatCache chatCache);

  /// 更多消息
  moreMessage({String? filter});

  /// 更多人
  morePersons({String? filter});

  /// 更多人
  bool hasMorePersons();

  /// 撤销消息
  Future<bool> recallMessage(String id);

  /// 删除消息
  Future<ApiResp> deleteMessage(String id);

  /// 清空历史消息
  clearMessage();

  /// 接收消息
  receiveMessage(MessageDetail detail, bool noRead);

  /// 发送消息
  Future<void> sendMsg({
    required MsgType msgType,
    required String msgBody,
  });

  /// 阅读所有消息
  readAll();

  /// 打开会话
  openChat();
}
