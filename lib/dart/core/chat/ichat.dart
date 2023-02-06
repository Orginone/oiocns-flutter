import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

/// 单个会话的抽象
abstract class IChat {
  final String userId;
  final String fullId;
  final String chatId;
  final bool isTopping;
  final String spaceId;
  final String spaceName;
  final int noReadCount;
  final int personCount;
  final ChatModel target;
  final List<XImMsg> messages;
  final List<XTarget> persons;
  final XImMsg? lastMessage;

  IChat({
    required this.userId,
    required this.fullId,
    required this.chatId,
    required this.isTopping,
    required this.spaceId,
    required this.spaceName,
    required this.noReadCount,
    required this.personCount,
    required this.target,
    required this.messages,
    required this.persons,
    this.lastMessage,
  });

  /// 获取会话缓存
  ChatCache getCache();

  /// 加载会话缓存
  /// [chatCache] 缓存数据
  loadCache(ChatCache chatCache);

  /// 更多消息
  /// [filter] 过滤条件
  Future<int> moreMessage({String? filter});

  /// 更多人
  Future<void> morePersons({String? filter});

  /// 发送消息
  Future<bool> sendMessage({
    required MessageType type,
    required String msgBody,
  });

  /// 撤销消息
  Future<void> recallMessage(String id);

  /// 删除消息
  Future<bool> deleteMessage(String id);

  /// 清空历史消息
  Future<bool> clearMessage();

  /// 接收消息
  receiveMessage(XImMsg detail, bool noRead);

  /// 读取所有
  readAll();
}

/// 会话组的抽象
abstract class IChatGroup {
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
}

/// 单个会话缓存
class ChatCache {
  final String chatId;
  final String spaceId;
  final bool isTopping;
  final int noReadCount;
  final XImMsg? lastMessage;

  const ChatCache({
    required this.chatId,
    required this.spaceId,
    required this.isTopping,
    required this.noReadCount,
    this.lastMessage,
  });

  ChatCache.fromMap(Map<String, dynamic> map)
      : chatId = map["chatId"],
        spaceId = map["spaceId"],
        noReadCount = map["noReadCount"],
        isTopping = map["isToping"],
        lastMessage = map["lastMessage"] == null
            ? null
            : XImMsg.fromJson(map["lastMessage"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["chatId"] = chatId;
    json["spaceId"] = spaceId;
    json["isToping"] = isTopping;
    json["noReadCount"] = noReadCount;
    json["lastMessage"] = lastMessage?.toJson();
    return json;
  }
}
