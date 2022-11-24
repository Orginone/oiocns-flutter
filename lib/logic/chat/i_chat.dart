import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/enumeration/message_type.dart';

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
  final int noReadCount;
  final MessageDetail? latestMsg;

  const ChatCache({
    required this.chatId,
    required this.spaceId,
    required this.noReadCount,
    required this.latestMsg,
  });
}

/// 单个会话的抽象
abstract class IChat {
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
  moreMessage(String filter);

  /// 更多人
  morePersons(String filter);

  /// 撤销消息
  Future<bool> recallMessage(String id);

  /// 删除消息
  Future<ApiResp> deleteMessage(String id);

  /// 清空历史消息
  clearMessage();

  /// 接收消息
  receiveMessage(MessageDetail detail, bool noRead);

  /// 发送消息
  Future<void> sendMsg(MsgType msgType, String msgBody);
}
