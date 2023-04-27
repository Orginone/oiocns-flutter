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
  late RxInt noReadCount;
  late RxInt personCount;
  late ChatModel target;
  late RxList<XImMsg> messages;
  late RxList<XTarget> persons;
  TargetShare get shareInfo;
  late int lastMsgTime;
  late Rx<XImMsg?> lastMessage;

  /// 获取会话缓存
  ChatCache getCache();

  /// 缓存会话
  cache();

  /// 销毁会话
  destroy();

  /// 会话初始化
  onMessage();

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
  receiveMessage(XImMsg msg);
}

/// 单个会话缓存
class ChatCache {
  final String fullId;
  final bool isTopping;
  final int noReadCount;
  final int? lastMsgTime;
  final XImMsg? lastMessage;

  const ChatCache({
    required this.fullId,
    required this.isTopping,
    required this.noReadCount,
    this.lastMsgTime,
    this.lastMessage,
  });

  ChatCache.fromMap(Map<String, dynamic> map)
      : fullId = map["fullId"],
        noReadCount = map["noReadCount"],
        isTopping = map["isToping"] ?? false,
        lastMsgTime = map["lastMsgTime"],
        lastMessage = map["lastMessage"] == null
            ? null
            : XImMsg.fromJson(map["lastMessage"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["fullId"] = fullId;
    json["isToping"] = isTopping;
    json["noReadCount"] = noReadCount;
    json["lastMsgTime"] = lastMsgTime;
    json["lastMessage"] = lastMessage?.toJson();
    return json;
  }
}
