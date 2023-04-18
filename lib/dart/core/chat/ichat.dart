import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';

/// 单个会话的抽象
abstract class IChat {
  late String userId;
  late String fullId;
  late String chatId;
  late RxBool isTopping;
  late String spaceId;
  late String spaceName;
  late RxInt noReadCount;
  late RxInt personCount;
  late ChatModel target;
  late RxList<XImMsg> messages;
  late RxList<XTarget> persons;
  late Rx<XImMsg?> lastMessage;
  late TargetShare shareInfo;

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
  Future<bool> sendMessage(MessageType type, String msgBody);

  /// 撤销消息
  Future<void> recallMessage(String id);

  /// 删除消息
  Future<bool> deleteMessage(String id);

  /// 清空历史消息
  Future<bool> clearMessage();

  /// 接收消息
  receiveMessage(XImMsg msg, bool noRead);
}

/// 会话组的抽象
abstract class IChatGroup {
  late String spaceId;
  late String spaceName;
  late RxBool isOpened;
  late RxList<IChat> chats;
}

/// 单个会话缓存
class ChatCache {
  final ChatModel target;
  final String spaceId;
  final String spaceName;
  final bool isTopping;
  final int noReadCount;
  final int? lastMsgTime;
  final XImMsg? lastMessage;

  const ChatCache({
    required this.target,
    required this.spaceId,
    required this.spaceName,
    required this.isTopping,
    required this.noReadCount,
    this.lastMsgTime,
    this.lastMessage,
  });

  ChatCache.fromMap(Map<String, dynamic> map)
      : target = ChatModel.fromJson(map["target"]),
        spaceId = map["spaceId"],
        spaceName = map["spaceName"],
        noReadCount = map["noReadCount"],
        isTopping = map["isToping"] ?? false,
        lastMsgTime = map["lastMsgTime"],
        lastMessage = map["lastMessage"] == null
            ? null
            : XImMsg.fromJson(map["lastMessage"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["target"] = target.toJson();
    json["spaceId"] = spaceId;
    json["spaceName"] = spaceName;
    json["isToping"] = isTopping;
    json["noReadCount"] = noReadCount;
    json["lastMsgTime"] = lastMsgTime;
    json["lastMessage"] = lastMessage?.toJson();
    return json;
  }
}
